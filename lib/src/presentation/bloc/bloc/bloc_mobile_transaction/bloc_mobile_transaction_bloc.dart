import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/create_collected_remittance_master_params/create_collected_remittance_master_params.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/create_member_unremitted_offline/create_member_unremitted_offline_params.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/get_member_remittance_status/get_member_remittance_status.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/get_remittance_master_donation_details/get_remittancer_master_donation_details_master.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/mobile_transaction_params.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/update_collector_agent_master/update_collector_agent_master.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/update_collector_remittance_ayannah/update_collector_remittance_ayannah.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/update_collector_remittance_brigadahan_headquarters/update_collector_remittance_brigadahan_headquarters.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/update_master_remittance_ayannah/update_master_remittance_ayannah_params.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/core/unremitted_donation/unremitted_donation.dart';
import 'package:kabrigadan_mobile/src/core/utils/enums/trasaction_type/transaction_type.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/error_message/error_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/success_message/success_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/warning_message/warning_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/mobile_transaction/show_member_remittance_master_helper.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/get_preferences.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/area_officer_master-in_progress/area_officer_master_in_progress.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/area_officer_master/area_officer_master.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/area_officer_master_local/area_officer_master_local.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/remitted_donation/remitted_donation.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation/unremitted_donation.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation/unremitted_donation_bulk_remit.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation/unremitted_donation_reference.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation_ui/unremitted_donation_ui.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation_ui_server/unremitted_donation_ui_server.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_current_user_remittance_master/get_current_user_remittance_items.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_current_user_remittance_master/get_current_user_remittance_master.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_remittance_master_status/remittancer_master_status.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/create_unpaid_collected_remittance_master/collected_remittance_master.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/member_unremitted_donation_model/member_unremitted_donation_model.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/member_unremitted_donation_results.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/mobile_transaction/mobile_transaction_use_case.dart';
import 'package:kabrigadan_mobile/src/presentation/widgets/messages/payment_prompt.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

part 'bloc_mobile_transaction_event.dart';

part 'bloc_mobile_transaction_state.dart';

class MobileTransactionBloc extends Bloc<MobileTransactionEvent, MobileTransactionState> {
  final SendMobileTransactionUseCase sendMobileTransactionUseCase;
  final UpdateCollectorAgentMasterRemittanceUseCase updateCollectorAgentMasterRemittanceUseCase;
  final GetRemittanceMasterDonationDetailsUseCase getRemittanceMasterDonationDetailsUseCase;
  final GetRemittanceMasterStatusUseCase getRemittanceMasterStatusUseCase;
  final GetCurrentUserRemittanceMasterUseCase getCurrentUserRemittanceMasterUseCase;
  final GetCurrentUserRemittanceMasterInProgressUseCase getCurrentUserRemittanceMasterInProgressUseCase;
  final GetCurrentUserRemittanceMasterCompletedUseCase getCurrentUserRemittanceMasterCompletedUseCase;
  final UpdateMasterRemittanceAyannahUseCase updateMasterRemittanceAyannahUseCase;
  final GetCurrentUserCollectedUnremittedDonationsUseCase getCurrentUserCollectedUnremittedDonationsUseCase;
  final CreateCollectedRemittanceMasterUseCase createCollectedRemittanceMasterUseCase;
  final UpdateCollectorRemittanceAyannahUseCase updateCollectorRemittanceAyannahUseCase;
  final UpdateCollectorRemittanceBrigadahanHeadQuarterUseCase updateCollectorRemittanceBrigadahanHeadQuarterUseCase;
  final CreateMemberUnRemittedDonationForOfflineUseCase createMemberUnRemittedDonationForOfflineUseCase;

  MobileTransactionBloc(
      this.sendMobileTransactionUseCase,
      this.updateCollectorAgentMasterRemittanceUseCase,
      this.getRemittanceMasterDonationDetailsUseCase,
      this.getRemittanceMasterStatusUseCase,
      this.getCurrentUserRemittanceMasterUseCase,
      this.updateMasterRemittanceAyannahUseCase,
      this.getCurrentUserRemittanceMasterInProgressUseCase,
      this.getCurrentUserRemittanceMasterCompletedUseCase,
      this.getCurrentUserCollectedUnremittedDonationsUseCase,
      this.createCollectedRemittanceMasterUseCase,
      this.updateCollectorRemittanceAyannahUseCase,
      this.updateCollectorRemittanceBrigadahanHeadQuarterUseCase,
      this.createMemberUnRemittedDonationForOfflineUseCase)
      : super(const SendingMobileTransaction()){
    on<SendMobileTransactionEvent>(_sendMobileTransaction);
    on<CreateCollectedRemittanceMasterEvent>(_createCollectedRemittanceMaster);
    on<UpdateCollectorAgentMasterEvent>(_updateCollectorAgentMasterRemittance);
    on<GetRemittanceMasterDetailsEvent>(_getRemittanceMasterDetails);
    on<ShowRemittanceMasterDetailsEvent>(_showRemittanceMasterDetails);
    on<GetCurrentUserRemittanceMasterEvent>(_getCurrentUserRemittanceMasterEvent);
    on<UpdateMasterRemittanceAyannahEvent>(_updateMasterRemittanceAyannah);
    on<SyncUnremittedDonationEvent>(_syncUnremittedDonationEvent);
    on<SyncUnremittedDonationCOEvent>(_syncCOUnremittedDonationsEvent);
    on<UpdateCollectorRemittanceAyannahEvent>(_updateCollectorRemittanceAyannah);
    on<UpdateCollectorRemittanceBrigadahanHeadQuarterEvent>(_updateCollectorRemittanceBrigadahanHeadQuarter);
    on<SendingMobileTransactionEvent>(_sendingMobileTransaction);
  }
  // @override
  // Stream<MobileTransactionState> mapEventToState(
  //     MobileTransactionEvent event,
  //     ) async* {
  //   if (event is SendMobileTransactionEvent) {
  //     yield* _sendMobileTransaction(event.mobileTransactionParams, event.context, event.toBeRemittedList, event.refresh);
  //   }
  //
  //   if (event is CreateCollectedRemittanceMasterEvent) {
  //     yield* _createCollectedRemittanceMaster(event.context, event.refresh2);
  //   }
  //
  //   if (event is UpdateCollectorAgentMasterEvent) {
  //     yield* _updateCollectorAgentMasterRemittance(event.updateCollectorAgentMasterParams);
  //   }
  //
  //   if (event is GetRemittanceMasterDetailsEvent) {
  //     yield* _getRemittanceMasterDetails(event.getRemittancerMasterDonationDetailsParams, event.memberRemittanceMasterId, event.context, event.refresh);
  //   }
  //
  //   if (event is ShowRemittanceMasterDetailsEvent) {
  //     _showRemittanceMasterDetails(event.getRemittancerMasterDonationDetailsParams, event.memberRemittanceMasterId, event.context);
  //   }
  //
  //   if (event is GetCurrentUserRemittanceMasterEvent) {
  //     yield* _getCurrentUserRemittanceMasterEvent();
  //   }
  //
  //   if (event is UpdateMasterRemittanceAyannahEvent) {
  //     yield* _updateMasterRemittanceAyannah(event.updateMasterRemittanceAyannahParams);
  //   }
  //   if(event is SyncUnremittedDonationEvent){
  //     yield* _syncUnremittedDonationEvent(event.context);
  //   }
  //   if(event is SyncUnremittedDonationCOEvent){
  //     yield* _syncCOUnremittedDonationsEvent();
  //   }
  //   if(event is UpdateCollectorRemittanceAyannahEvent){
  //     yield* _updateCollectorRemittanceAyannah();
  //   }
  //   if(event is UpdateCollectorRemittanceBrigadahanHeadQuarterEvent){
  //     yield* _updateCollectorRemittanceBrigadahanHeadQuarter();
  //   }
  // }

  List<AreaOfficerMasterInProgress> areaOfficerMasterInProgressList = [];
  List<AreaOfficerMaster> areaOfficerMasterCompleteList = [];
  final currentUserBox = Hive.box('currentUser');
  final remittedDonationBox = Hive.box('remittedDonations');
  final unremittedDonationReferenceBox = Hive.box('unremittedDonationReference');
  Timer? timer;
  bool timerDone = false;

  void _sendingMobileTransaction(SendingMobileTransactionEvent event, Emitter<MobileTransactionState> emit) async{
    emit(const SendingMobileTransaction());
  }


  void _createCollectedRemittanceMaster(CreateCollectedRemittanceMasterEvent event, Emitter<MobileTransactionState> emit) async {
    emit(const GetCurrentUserMasterRemittanceLoadingState());
    timerDone = false;
    var logger = Logger();

    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;
    String? accessToken = await GetPreferences().getStoredAccessToken();
    String? accessTokenRes = 'Bearer $accessToken';
    final masterRemittanceBox = Hive.box('areaOfficerMasterInProgress');
    final unremittedDonationBulkRemitBox = Hive.box('unremittedDonationBulkRemit');
    List<Map<String, dynamic>> bulkMemberList = [];
    bulkMemberList.clear();

    List<dynamic> inProgressDonationUiList = masterRemittanceBox.values.toList();

    logger.i(inProgressDonationUiList);

    // for (var i in inProgressDonationUiList) {
    //   AreaOfficerMasterInProgress inProgressDonation = i as AreaOfficerMasterInProgress;
    //   //DONE CREATED AreaOfficerMasterInProgress in JSON FORMAT ready for calling an API
    //   if(i.referenceNumberAO == null){
    //     Map<String, dynamic> sampleJson = {
    //       "agentMemberId": inProgressDonation.agentMemberId,
    //       "referenceNumber": inProgressDonation.referenceNumber,
    //       "status": inProgressDonation.status,
    //       "transactionSourceType": 1,
    //       "isVerified": false,
    //       "amount": inProgressDonation.amount,
    //       "collectorAgentId": inProgressDonation.agentMemberId,
    //       "id": inProgressDonation.memberRemittanceMasterID
    //     };
    //
    //     bulkMemberList.add(sampleJson);
    //   }
    // }

    final dataState = await createCollectedRemittanceMasterUseCase(params: CreateCollectedRemittanceMasterParams(authorizationHeader: accessTokenRes, collectorMemberId: currentUser.memberId));

    logger.i(dataState);

    if (dataState.data != null) {

      UnremittedDonationBulkRemit unremittedDonationBulkRemit = UnremittedDonationBulkRemit(
        id: dataState.data!.collectedRemittanceMasterModel!.referenceNumber
      );
      unremittedDonationBulkRemitBox.add(unremittedDonationBulkRemit);
    }
    timerDone = true;
    emit(const GetCurrentUserMasterRemittanceDoneState());
  }

  void _sendMobileTransaction(SendMobileTransactionEvent event, Emitter<MobileTransactionState> emit) async {
    emit(const GetCurrentUserMasterRemittanceLoadingState());
    timerDone = false;
    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;
    var logger = Logger();

    String? accessToken = await GetPreferences().getStoredAccessToken();
    String? accessTokenRes = 'Bearer $accessToken';

    logger.i(accessToken);

    final dataState = await sendMobileTransactionUseCase(
        params:
            MobileTransactionParams(accessToken: accessTokenRes, agentMemberId: event.mobileTransactionParams.agentMemberId, memberUnRemittedDonations: event.mobileTransactionParams.memberUnRemittedDonations));

    logger.i(dataState.data);

    if (dataState.data != null) {
      String? referenceNumber = dataState.data!.referenceNumber;
      UnremittedDonations.referenceNumber = referenceNumber;
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

      showDialog(
          context: event.context,
          builder: (context) => AlertDialog(
                title: const Text('Remit your collection'),
                content: _qrFormAO(areaOfficerQR, referenceNumber, amount.toString(), currentUser),
                actions: [
                  TextButton(
                      onPressed: () {
                        showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) => PaymentPrompt(
                            isDonor: false,
                            camera: firstCamera,
                            currentUser: currentUser,
                            toBeRemittedList: event.toBeRemittedList,
                            qrData: ayannahQR,
                            masterRemittanceId: masterRemittanceId,
                            communityOfficer: currentUser,
                            amount: amount,
                            referenceNumber: referenceNumber,
                            refresh: event.refresh,
                          ),
                        );
                      },
                      child: const Text('Remit Collection'))
                ],
              ));

      // showDialog(
      //     context: context,
      //     barrierDismissible: false,
      //     builder: (_) =>
      //         QrAyannah(amount: UnremittedDonations.amount.toString(), referenceNumber: referenceNumber, camera: firstCamera, currentUser: currentUser, toBeRemittedList: toBeRemittedList,
      //           masterRemittanceId: masterRemittanceId));

    } else {
      showDialog(
          context: event.context,
          barrierDismissible: false,
          builder: (context) => ErrorMessage(
              title: "Error",
              content: dataState.error!.error.toString(),
              onPressedFunction: () {
                Navigator.pop(context);
              }));
    }
    timerDone = true;
    emit(const GetCurrentUserMasterRemittanceDoneState());
  }

  Widget _qrFormAO(String areaOfficerQR, String? referenceNumber, String amount, CurrentUser currentUser) {
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
              text: TextSpan(children: [
                TextSpan(
                  text: '$referenceNumber\n',
                  style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: 'Reference Number',
                  style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w500),
                )
              ]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.0.h),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Php ${double.parse(amount).toStringAsFixed(2)}\n',
                  style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: 'Amount',
                  style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w500),
                )
              ]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.0.h),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '${currentUser.name}\n',
                  style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: 'Name',
                  style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w500),
                )
              ]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.0.h),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '${currentUser.idNumber}\n',
                  style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: 'ID Number',
                  style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w500),
                )
              ]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _updateCollectorAgentMasterRemittance(UpdateCollectorAgentMasterEvent event, Emitter<MobileTransactionState> emit) async {
    var logger = Logger();
    final dataState = await updateCollectorAgentMasterRemittanceUseCase(
        params: UpdateCollectorAgentMasterParams(masterRemittanceId: event.updateCollectorAgentMasterParams.masterRemittanceId, collectorAgentId: event.updateCollectorAgentMasterParams.collectorAgentId));

    logger.i(event.updateCollectorAgentMasterParams.masterRemittanceId);
    logger.i(event.updateCollectorAgentMasterParams.collectorAgentId);
    logger.i(dataState);
    unremittedDonationReferenceBox.clear();
  }

  void _updateMasterRemittanceAyannah(UpdateMasterRemittanceAyannahEvent event, Emitter<MobileTransactionState> emit) async {
    var logger = Logger();

    final dataState = await updateMasterRemittanceAyannahUseCase(
        params: UpdateMasterRemittanceAyannahParams(
            masterRemittanceId: event.updateMasterRemittanceAyannahParams.masterRemittanceId,
            transactionId: event.updateMasterRemittanceAyannahParams.transactionId,
            receiptFileAttachment: event.updateMasterRemittanceAyannahParams.receiptFileAttachment));

    logger.i(dataState);
  }

  void _getRemittanceMasterDetails(GetRemittanceMasterDetailsEvent event, Emitter<MobileTransactionState> emit) async {
    var logger = Logger();
    final masterRemittanceBox = Hive.box('areaOfficerMaster');
    final unremittedDonationBox = Hive.box('unremittedDonations');
    final unremittedDonationUiBox = Hive.box('unremittedDonationsUi');

    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;

    List<dynamic> listAreaOfficerMaster = masterRemittanceBox.values.toList();

    final dataState = await getRemittanceMasterDonationDetailsUseCase(
        params: GetRemittancerMasterDonationDetailsParams(
            authorizationHeader: event.getRemittancerMasterDonationDetailsParams.authorizationHeader, memberRemittanceMasterId: event.getRemittancerMasterDonationDetailsParams.memberRemittanceMasterId));

    logger.i(dataState.data);

    if (dataState.data != null) {
      List<MemberUnremittedDonationResultsEntity> listMemberUnremittedDonationModel = dataState.data!;

      for (int i = 0; i < listAreaOfficerMaster.length; i++) {
        AreaOfficerMaster areaOfficerMaster = listAreaOfficerMaster[i] as AreaOfficerMaster;

        if (areaOfficerMaster.memberRemittanceMasterID == event.memberRemittanceMasterId) {
          masterRemittanceBox.deleteAt(i);
        }
      }

      for (MemberUnremittedDonationResultsEntity element in listMemberUnremittedDonationModel) {
        MemberUnremittedDonationModel memberUnremittedDonationModel = element as MemberUnremittedDonationModel;
        Map<String, dynamic> jsonUnremittedDonation = memberUnremittedDonationModel.toJson();

        UnremittedDonation unremittedDonation = UnremittedDonation.fromJson(jsonUnremittedDonation);
        UnremittedDonationUi unremittedDonationUi = UnremittedDonationUi.fromJson(jsonUnremittedDonation);

        logger.i(unremittedDonation);
        logger.i(unremittedDonationUi);

        unremittedDonation.creatorId = currentUser.memberId;
        unremittedDonationUi.creatorId = currentUser.memberId;

        unremittedDonationUi.dateRecorded = DateTime.now();

        unremittedDonationBox.add(unremittedDonation);
        unremittedDonationUiBox.add(unremittedDonationUi);
      }

      final masterRemittanceInProgressBox = Hive.box('areaOfficerMasterInProgress');
      List<dynamic> masterRemittanceInProgressList = masterRemittanceInProgressBox.values.toList();

      logger.i(masterRemittanceInProgressList);

      AreaOfficerLoop:
      for (int i = 0; i < masterRemittanceInProgressList.length; i++) {
        AreaOfficerMasterInProgress areaOfficerMasterInProgress = masterRemittanceInProgressList[i] as AreaOfficerMasterInProgress;

        if (areaOfficerMasterInProgress.memberRemittanceMasterID == event.memberRemittanceMasterId) {
          masterRemittanceInProgressBox.deleteAt(i);
          logger.i(i);
          break AreaOfficerLoop;
        }
      }

      showDialog(
          context: event.context,
          builder: (context) => SuccessMessage(
              title: "Success!",
              content: "Successfully reverted unremitted donations.",
              onPressedFunction: () {
                Navigator.pop(context);
                Navigator.pop(context);
                event.refresh();
              }));
    }
  }

  void _showRemittanceMasterDetails(ShowRemittanceMasterDetailsEvent event, Emitter<MobileTransactionState> emit) async {
    final dataState = await getRemittanceMasterDonationDetailsUseCase(
        params: GetRemittancerMasterDonationDetailsParams(
            authorizationHeader: event.getRemittancerMasterDonationDetailsParams.authorizationHeader, memberRemittanceMasterId: event.getRemittancerMasterDonationDetailsParams.memberRemittanceMasterId));

    ShowMemberRemittanceMasterHelper.listMemberMasters.value = [];

    if (dataState.data != null) {
      List<MemberUnremittedDonationResultsEntity> listMemberUnremittedDonationModel = dataState.data!;
      ShowMemberRemittanceMasterHelper.listMemberMasters.value = listMemberUnremittedDonationModel;
    }
  }

  Future<void> syncRemittedMasterStatus() async {
    final masterRemittanceBox = Hive.box('areaOfficerMaster');
    List<dynamic> memberRemittanceMasterList = masterRemittanceBox.values.toList();

    String? accessToken = await GetPreferences().getStoredAccessToken();
    String? accessTokenRes = 'Bearer $accessToken';

    List<String> jsonCOList = [];
    for (var i in memberRemittanceMasterList) {
      AreaOfficerMaster areaOfficerMaster = i as AreaOfficerMaster;
      if (areaOfficerMaster.status == 1) {
        jsonCOList.add(areaOfficerMaster.memberRemittanceMasterID.toString());
      }
    }

    GetMemberRemittanceStatusParams getMemberRemittanceStatusParams = GetMemberRemittanceStatusParams(authorizationHeader: accessTokenRes, remittanceMasterId: jsonCOList);

    final donationCOState = await getRemittanceMasterStatusUseCase(params: getMemberRemittanceStatusParams);

    if (donationCOState.data != null) {
      _updateIdAndStatusCO(memberRemittanceMasterList, donationCOState);
    }
  }

  void _updateIdAndStatusCO(List<dynamic> memberRemittanceMasterList, DataState<List<RemittanceMasterStatus>> donationState) {
    for (var i in memberRemittanceMasterList) {
      AreaOfficerMaster areaOfficerMaster = i as AreaOfficerMaster;

      for (var j in donationState.data!) {
        RemittanceMasterStatus remittanceMasterStatus = j;

        if (areaOfficerMaster.memberRemittanceMasterID == remittanceMasterStatus.remittanceMasterId) {
          int replacementStatus = remittanceMasterStatus.status!;
          areaOfficerMaster.status = replacementStatus;
        }
      }
    }
  }

  void _getCurrentUserRemittanceMasterEvent(GetCurrentUserRemittanceMasterEvent event, Emitter<MobileTransactionState> emit) async {
    emit(const GetCurrentUserMasterRemittanceLoadingState());
    timerDone = false;
    var logger = Logger();
    final masterRemittanceBox = Hive.box('areaOfficerMaster');
    final masterRemittanceInProgressBox = Hive.box('areaOfficerMasterInProgress');
    final unremittedDonationUiBox = Hive.box('unremittedDonationsUi');
    final unremittedDonationUiServerBox = Hive.box('unremittedDonationUiServer');

    String? accessToken = await GetPreferences().getStoredAccessToken();
    String? accessTokenRes = 'Bearer $accessToken';

    final dataState = await getCurrentUserRemittanceMasterInProgressUseCase(params: accessTokenRes);
    final dataState2 = await getCurrentUserRemittanceMasterCompletedUseCase(params: accessTokenRes);
    final dataState3 = await getCurrentUserCollectedUnremittedDonationsUseCase(params: accessTokenRes);

    masterRemittanceBox.clear();
    areaOfficerMasterCompleteList.clear();
    List<dynamic> masterRemittanceInProgressList = masterRemittanceInProgressBox.values.toList();

    if (dataState.data != null) {
      areaOfficerMasterInProgressList.clear();
      masterRemittanceInProgressBox.clear();
      GetCurrentUserRemittanceMaster getCurrentUserRemittanceMasterInProgress = dataState.data!;
      for (GetCurrentUserRemittanceItems item in getCurrentUserRemittanceMasterInProgress.getCurrentUserRemittanceItems!) {
        bool check = false;
        int? indexTransactionType = item.transactionSourceType == 0 ? item.transactionSourceType! + 3 : item.transactionSourceType! - 1;

        for(AreaOfficerMasterInProgress i in masterRemittanceInProgressList){
          if(i.referenceNumber == item.referenceNumber && i.status == item.status){
            check = true;
          }
        }
        if(!check){
          AreaOfficerMasterInProgress areaOfficerMasterInProgress = AreaOfficerMasterInProgress(
              referenceNumber: item.referenceNumber,
              amount: item.amount.toString(),
              status: item.status,
              communityOfficeId: item.agentMemberId,
              communityOfficerName: item.agentMemberName,
              communityOfficerMemberId: item.agentMemberId,
              memberRemittanceMasterID: item.id,
              isAreaOfficer: true,
              agentMemberId: item.agentMemberId,
              agentMemberIdNumber: item.agentMemberIdNumber,
              dateCreated: item.collectedDate.toString(),
              creatorID: item.collectorAgentId,
              transactionType: TransactionType.transactionTypeRemittanceMaster[indexTransactionType],
              referenceNumberAO: item.aoReferenceNumber,
              collectorAgentIdNumber: item.agentMemberIdNumber,
              overideMemberRemittanceMasterId: item.overideMemberRemittanceMasterId
          );

          masterRemittanceInProgressBox.add(areaOfficerMasterInProgress);
          areaOfficerMasterInProgressList.add(areaOfficerMasterInProgress);
        }

      }

      for(AreaOfficerMasterInProgress i in masterRemittanceInProgressList){
        areaOfficerMasterInProgressList.add(i);
      }
      // List<dynamic> memberRemittanceMasterInProgressList = masterRemittanceInProgressBox.values.toList();
      // for (var element in memberRemittanceMasterInProgressList) {
      //   AreaOfficerMasterInProgress areaOfficerMasterInProgress = element as AreaOfficerMasterInProgress;
      //   areaOfficerMasterInProgressList.add(areaOfficerMasterInProgress);
      // }
    }

    if (dataState2.data != null) {
      GetCurrentUserRemittanceMaster getCurrentUserRemittanceMasterComplete = dataState2.data!;
      for (GetCurrentUserRemittanceItems item in getCurrentUserRemittanceMasterComplete.getCurrentUserRemittanceItems!) {
        int? indexTransactionType = item.transactionSourceType == 0 ? item.transactionSourceType : item.transactionSourceType! - 1;

        AreaOfficerMaster areaOfficerMasterComplete = AreaOfficerMaster(
            referenceNumber: item.referenceNumber,
            amount: item.amount.toString(),
            status: item.status,
            communityOfficeId: item.agentMemberId,
            communityOfficerName: item.agentMemberName,
            communityOfficerMemberId: item.agentMemberId,
            memberRemittanceMasterID: item.id,
            isAreaOfficer: true,
            agentMemberId: item.agentMemberId,
            agentMemberIdNumber: item.agentMemberIdNumber,
            dateCreated: item.collectedDate.toString(),
            creatorID: item.collectorAgentId,
            transactionType: TransactionType.transactionTypeRemittanceMaster[indexTransactionType!],
            completedDate: item.completedDate.toString());
            masterRemittanceBox.add(areaOfficerMasterComplete);

      }

      List<dynamic> memberRemittanceMasterCompleteList = masterRemittanceBox.values.toList();
      for (var i in memberRemittanceMasterCompleteList) {
        AreaOfficerMaster areaOfficerMaster = i as AreaOfficerMaster;
        areaOfficerMasterCompleteList.add(areaOfficerMaster);
      }
    }

    if (dataState3.data != null) {
      unremittedDonationUiServerBox.clear().then((_) {
        List<MemberUnremittedDonationModel> getCurrentUserCollectedUnremittedDonations = dataState3.data!.listMemberUnremittedDonationModel!;
        for (MemberUnremittedDonationModel item in getCurrentUserCollectedUnremittedDonations) {
          UnremittedDonationUi unremittedDonationUi = UnremittedDonationUi(
              caseCode: item.caseCode,
              amount: item.amount,
              donatedByMemberIdNumber: item.donatedByMemberIdNumber,
              name: item.donatedByName,
              agentMemberIdNumber: item.agentMemberIdNumber,
              status: item.status,
              memberRemittanceMasterId: item.memberRemittanceMasterId,
              ayannahAttachment: item.ayannahAttachment,
              unremittedTempId: item.unremittedTempId,
              id: item.id);

          Map<String, dynamic> jsonUnremittedDonationUi = unremittedDonationUi.toJson();
          UnremittedDonationUiServer unremittedDonationUiServer = UnremittedDonationUiServer.fromJson(jsonUnremittedDonationUi);

          logger.i(unremittedDonationUiServer);

          unremittedDonationUiBox.add(unremittedDonationUi);
          unremittedDonationUiServerBox.add(unremittedDonationUiServer);
        }
      });
    }
    timerDone = true;
    emit(const GetCurrentUserMasterRemittanceDoneState());
  }

  void _syncUnremittedDonationEvent(SyncUnremittedDonationEvent event, Emitter<MobileTransactionState> emit) async {
    emit(const GetCurrentUserMasterRemittanceLoadingState());
    timerDone = false;
    /// Sync Method
    /// API Call
    var logger = Logger();

      final unremittedDonationReferenceBox = Hive.box('unremittedDonationReference');
      var unremittedDonationReferenceBoxList =  unremittedDonationReferenceBox.values.toList();

      for(UnremittedDonationReference ds in unremittedDonationReferenceBoxList){
        if(ds.transactionType == 'Ayannah'){
          UpdateMasterRemittanceAyannahParams updateMasterRemittanceAyannahParams = UpdateMasterRemittanceAyannahParams(
              masterRemittanceId: ds.memberRemittanceMasterId,
              receiptFileAttachment: null,
              transactionId: null
          );
          final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(event.context);
          mobileTransactionBloc.add(UpdateMasterRemittanceAyannahEvent(updateMasterRemittanceAyannahParams: updateMasterRemittanceAyannahParams));
        }
        if(ds.transactionType == 'Kabrigadahan Officer'){
          UpdateCollectorAgentMasterParams updateCollectorAgentMasterParams =
          UpdateCollectorAgentMasterParams(
              masterRemittanceId: ds.memberRemittanceMasterId,
              collectorAgentId: ds.collectorAgentId
          );

          final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(event.context);
          mobileTransactionBloc.add(UpdateCollectorAgentMasterEvent(updateCollectorAgentMasterParams: updateCollectorAgentMasterParams));
        }
      }

      for(UnremittedDonationReference ds in unremittedDonationReferenceBoxList){
        if(ds.transactionType != null){
          unremittedDonationReferenceBox.clear();
        }
      }
      logger.i('Syncing Complete!');
    timerDone = true;
    emit(const GetCurrentUserMasterRemittanceDoneState());
  }

  void _syncCOUnremittedDonationsEvent(SyncUnremittedDonationCOEvent event, Emitter<MobileTransactionState> emit) async {
    emit(const GetCurrentUserMasterRemittanceLoadingState());
    timerDone = false;
    final unremittedDonationUiBox = Hive.box('unremittedDonationsUi');
    final unremittedDonationBox = Hive.box('unremittedDonations');
    final currentUserBox = Hive.box('currentUser');

    List<dynamic> unremittedDonationList = unremittedDonationBox.values.toList();
    List<dynamic> unremittedDonationUiList = unremittedDonationUiBox.values.toList();
    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;

    List<Map<String, dynamic>> jsonCOList = [];
    for (var i in unremittedDonationUiList) {
      UnremittedDonationUi unremittedDonationUi = i as UnremittedDonationUi;
      if (unremittedDonationUi.creatorId == currentUser.memberId) {
        Map<String, dynamic> jsonCOUnremitted = unremittedDonationUi.toJsonSyncing();
        jsonCOList.add(jsonCOUnremitted);
      }
    }

    final donationCOState = await createMemberUnRemittedDonationForOfflineUseCase(params: CreateMemberUnremittedOfflineParams(jsonCOList));

    if(donationCOState.data != null){
      _updateIdAndStatusCOSync(unremittedDonationList, donationCOState);
      _updateIdAndStatusCOUiSync(unremittedDonationUiList, donationCOState);
    }

    //Remove item if status is Remitted
    for(int i=0; i<unremittedDonationUiList.length; i++){
      UnremittedDonationUi unremittedDonation = unremittedDonationUiList[i] as UnremittedDonationUi;
      if (unremittedDonation.status == 3) {
        int index = i;
        unremittedDonationUiBox.deleteAt(index);
      }
    }
    timerDone = true;
   emit(const GetCurrentUserMasterRemittanceDoneState());
  }
  void _updateIdAndStatusCOSync(List<dynamic> unremittedDonationsBoxList, DataState<List<MemberUnremittedDonationResultsEntity>> donationState) {
    for (var i in unremittedDonationsBoxList) {
      UnremittedDonation unremittedDonation = i as UnremittedDonation;

      for(var j in donationState.data!){
        MemberUnremittedDonationModel memberUnremittedDonationModel = j as MemberUnremittedDonationModel;

        if(memberUnremittedDonationModel.unremittedTempId == unremittedDonation.unremittedTempId){
          String replacementId = memberUnremittedDonationModel.id.toString();
          int replacementStatus = memberUnremittedDonationModel.status!;
          unremittedDonation.id = replacementId;
          unremittedDonation.status = replacementStatus;
        }
      }
    }
  }
  void _updateIdAndStatusCOUiSync(List<dynamic> unremittedDonationsUiBoxList, DataState<List<MemberUnremittedDonationResultsEntity>> donationState) {
    for (var i in unremittedDonationsUiBoxList) {
      UnremittedDonationUi unremittedDonationUi = i as UnremittedDonationUi;

      for(var j in donationState.data!){
        MemberUnremittedDonationModel memberUnremittedDonationModel = j as MemberUnremittedDonationModel;

        if(memberUnremittedDonationModel.unremittedTempId == unremittedDonationUi.unremittedTempId){
          String replacementId = memberUnremittedDonationModel.id.toString();
          int replacementStatus = memberUnremittedDonationModel.status!;
          unremittedDonationUi.id = replacementId;
          unremittedDonationUi.status = replacementStatus;
        }
      }
    }
  }

  void _updateCollectorRemittanceAyannah(UpdateCollectorRemittanceAyannahEvent event, Emitter<MobileTransactionState> emit) async {
     /// TODO call api to update payment in ayannah
    final unremittedDonationBulkRemitBox = Hive.box('unremittedDonationBulkRemit');
    var unremittedDonationBulkRemitBoxList = unremittedDonationBulkRemitBox.values.toList();

    String? accessToken = await GetPreferences().getStoredAccessToken();
    String? accessTokenRes = 'Bearer $accessToken';

    if(unremittedDonationBulkRemitBox.length > 0){
      for(UnremittedDonationBulkRemit ds in unremittedDonationBulkRemitBoxList){
        UpdateCollectorRemittanceAyannahParams updateCollectorRemittanceAyannahParams = UpdateCollectorRemittanceAyannahParams(authorizationHeader: accessTokenRes, collectedRemittanceMasterId: ds.id);
        final dataState = await updateCollectorRemittanceAyannahUseCase(params: updateCollectorRemittanceAyannahParams);
        unremittedDonationBulkRemitBox.clear();
      }
    }
  }

  void _updateCollectorRemittanceBrigadahanHeadQuarter(UpdateCollectorRemittanceBrigadahanHeadQuarterEvent event, Emitter<MobileTransactionState> emit) async {
    /// TODO call api to update payment in kabriagdahan headquarters
    final unremittedDonationBulkRemitBox = Hive.box('unremittedDonationBulkRemit');
    var unremittedDonationBulkRemitBoxList = unremittedDonationBulkRemitBox.values.toList();

    String? accessToken = await GetPreferences().getStoredAccessToken();
    String? accessTokenRes = 'Bearer $accessToken';

    if(unremittedDonationBulkRemitBox.length > 0){
      for(UnremittedDonationBulkRemit ds in unremittedDonationBulkRemitBoxList){
        UpdateCollectorRemittanceBrigadahanHeadquartersParams updateCollectorRemittanceBrigadahanHeadquartersParams = UpdateCollectorRemittanceBrigadahanHeadquartersParams(authorizationHeader: accessTokenRes, collectedRemittanceMasterId: ds.id);
        final dataState = await updateCollectorRemittanceBrigadahanHeadQuarterUseCase(params: updateCollectorRemittanceBrigadahanHeadquartersParams);
        unremittedDonationBulkRemitBox.clear();
      }
    }
  }
}
