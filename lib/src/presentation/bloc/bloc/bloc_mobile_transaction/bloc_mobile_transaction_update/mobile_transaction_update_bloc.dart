import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/mobile_transaction_params.dart';
import 'package:kabrigadan_mobile/src/core/unremitted_donation/unremitted_donation.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/error_message/error_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/warning_message/warning_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/get_preferences.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/remitted_donation/remitted_donation.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation/unremitted_donation.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation/unremitted_donation_reference.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/mobile_transaction/mobile_transaction_use_case.dart';
import 'package:kabrigadan_mobile/src/presentation/widgets/messages/payment_prompt.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

part 'mobile_transaction_update_event.dart';

part 'mobile_transaction_update_state.dart';

class MobileTransactionUpdateBloc extends Bloc<MobileTransactionUpdateEvent, MobileTransactionUpdateState> {
  final SendMobileTransactionUseCase sendMobileTransactionUseCase;
  MobileTransactionUpdateBloc(this.sendMobileTransactionUseCase) : super(MobileTransactionUpdateInitial()){
    on<MobileTransactionInitialEvent>(_mobileTransactionInitialEvent);
    on<RemitMobileTransactionEvent>(_sendMobileTransaction);
  }

  final currentUserBox = Hive.box('currentUser');
  final myUnremittedDonationBox = Hive.box('unremittedDonations');
  final myUnremittedDonationUiBox = Hive.box('unremittedDonationsUi');
  final unremittedDonationReferenceBox = Hive.box('unremittedDonationReference');


  // @override
  // Stream<MobileTransactionUpdateState> mapEventToState(
  //   MobileTransactionUpdateEvent event,
  // ) async* {
  //   if (event is RemitMobileTransactionEvent) {
  //     yield* _sendMobileTransaction(event.mobileTransactionParams, event.context, event.toBeRemittedList, event.refresh, event.hasCached);
  //   }
  // }

  void _mobileTransactionInitialEvent(MobileTransactionInitialEvent event, Emitter<MobileTransactionUpdateState> emit) async{
    emit(MobileTransactionUpdateInitial());
  }

  void _sendMobileTransaction(RemitMobileTransactionEvent event, Emitter<MobileTransactionUpdateState> emit) async {
    emit(const RemitLoadingMobileTransactionState());

    if(!event.hasCached){
      CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;

      var logger = Logger();

      String? accessToken = await GetPreferences().getStoredAccessToken();
      String? accessTokenRes = 'Bearer $accessToken';

      logger.i(accessToken);

      final dataState = await sendMobileTransactionUseCase(
          params: MobileTransactionParams(accessToken: accessTokenRes, agentMemberId: event.mobileTransactionParams.agentMemberId, memberUnRemittedDonations: event.mobileTransactionParams.memberUnRemittedDonations));

      logger.i(dataState.data);

      if (dataState.data != null) {
        String? referenceNumber = dataState.data!.referenceNumber;
        var unremittedDonationBoxList = myUnremittedDonationBox.values.toList();
        for(UnremittedDonation ds in unremittedDonationBoxList){
          ds.referenceNumber ??= dataState.data!.referenceNumber;
        }
        String? masterRemittanceId = dataState.data!.memberRemittanceMasterId;
        double? amount = dataState.data!.amount;

        int? status = dataState.data!.status;

        final cameras = await availableCameras();
        final firstCamera = cameras.first;

        String ayannahQR = '{'
            '\"amount\": ${UnremittedDonations.amount.toString()},'
            '\"referenceNumber\": \"$referenceNumber\",'
            '\"communityOfficeIdNumber\": \"${currentUser.memberId}\"'
            '}';

        String areaOfficerQR = '{'
            '\"amount\": $amount,'
            '\"referenceNumber\": \"$referenceNumber\",'
            '\"communityOfficeIdNumber\": \"${currentUser.idNumber}\",'
            '\"communityOfficeName\": \"${currentUser.name}\",'
            '\"communityOfficeMemberId\": \"${currentUser.memberId}\",'
            '\"memberRemittanceMasterID\": \"$masterRemittanceId\"'
            '}';

        ///TODO Save reference number
        /// Save reference in local if don't have a internet
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult != ConnectivityResult.mobile || connectivityResult != ConnectivityResult.wifi) {
          UnremittedDonationReference unremittedDonationReference = UnremittedDonationReference(
            referenceNumber: referenceNumber,
            memberRemittanceMasterId: masterRemittanceId,
            amount: amount
          );
          unremittedDonationReferenceBox.add(unremittedDonationReference);
        }

        showDialog(
            context: event.context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Remit your collection'),
                content: _qrFormAO(
                    areaOfficerQR, referenceNumber, amount.toString(),
                    currentUser),
                actions: [
                  TextButton(
                      onPressed: () {
                        showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) =>
                              PaymentPrompt(isDonor: false,
                                camera: firstCamera,
                                currentUser: currentUser,
                                toBeRemittedList: event.toBeRemittedList,
                                qrData: ayannahQR,
                                masterRemittanceId: masterRemittanceId,
                                communityOfficer: currentUser,
                                amount: amount,
                                referenceNumber: referenceNumber,
                                refresh: event.refresh),
                        );
                      },
                      child: const Text('Remit Collection')
                  )
                ],
              );

            }
        );

      } else {
        showDialog(
            context: event.context,
            barrierDismissible: false,
            builder: (context) => ErrorMessage(title: "Error", content: dataState.error!.error.toString(), onPressedFunction: (){
              Navigator.pop(context);
            }));
      }
    }
    else{
      int counter = 0;
      UnremittedDonationReference cached = UnremittedDonationReference();
      if(unremittedDonationReferenceBox.length <= 0){
        counter++;
      } else {
        cached = unremittedDonationReferenceBox.values.first;
        var unremittedDonationList = myUnremittedDonationBox.values.toList();
        for(UnremittedDonation ds in unremittedDonationList){
          if(ds.referenceNumber == null){
            counter++;
          }
        }
      }

      if(counter > 0){
        showDialog(context: event.context, builder: (context) => const WarningMessage(title: "Warning", content: "No internet connection. Please try again later."));
      }
      else {
        CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;
        final cameras = await availableCameras();
        final firstCamera = cameras.first;

        String ayannahQR = '{'
            '\"amount\": ${UnremittedDonations.amount.toString()},'
            '\"referenceNumber\": \"${cached.referenceNumber}\",'
            '\"communityOfficeIdNumber\": \"${currentUser.memberId}\"'
            '}';

        String areaOfficerQR = '{'
            '\"amount\": ${cached.amount.toString()},'
            '\"referenceNumber\": \"${cached.referenceNumber.toString()}\",'
            '\"communityOfficeIdNumber\": \"${currentUser.idNumber}\",'
            '\"communityOfficeName\": \"${currentUser.name}\",'
            '\"communityOfficeMemberId\": \"${currentUser.memberId}\",'
            '\"memberRemittanceMasterID\": \"${cached.memberRemittanceMasterId.toString()}\"'
            '}';

        showDialog(
            context: event.context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Remit your collection'),
                content: _qrFormAO(areaOfficerQR, cached.referenceNumber, cached.amount.toString(),currentUser),
                actions: [
                  TextButton(
                      onPressed: () {
                        showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) =>
                              PaymentPrompt(isDonor: false,
                                  camera: firstCamera,
                                  currentUser: currentUser,
                                  toBeRemittedList: event.toBeRemittedList,
                                  qrData: ayannahQR,
                                  masterRemittanceId: cached.memberRemittanceMasterId,
                                  communityOfficer: currentUser,
                                  amount: cached.amount,
                                  referenceNumber: cached.referenceNumber,
                                  refresh: event.refresh),
                        );
                      },
                      child: const Text('Remit Collection')
                  )
                ],
              );
            }
        );
      }
    }

    emit(const RemitDoneMobileTransactionStateDone());
  }

  Widget _qrFormAO(String areaOfficerQR, String? referenceNumber, String amount, CurrentUser currentUser){
    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 250,
                width: 250,
                child: Center(
                  child: QrImage(
                    data: areaOfficerQR,
                    size: 350.0,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$referenceNumber\n',
                      style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: 'Reference Number',
                      style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w500),
                    )
                  ]
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.0.h),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Php ${double.parse(amount).toStringAsFixed(2)}\n',
                      style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: 'Amount',
                      style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w500),
                    )
                  ]
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.0.h),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${currentUser.name}\n',
                      style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: 'Name',
                      style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w500),
                    )
                  ]
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.0.h),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${currentUser.idNumber}\n',
                      style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: 'ID Number',
                      style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w500),
                    )
                  ]
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
