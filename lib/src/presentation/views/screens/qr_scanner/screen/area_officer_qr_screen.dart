import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/update_collector_agent_master/update_collector_agent_master.dart';
import 'package:kabrigadan_mobile/src/core/utils/area_officer_helper_model.dart';
import 'package:kabrigadan_mobile/src/core/utils/enums/trasaction_type/transaction_type.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/reminder_message/reminder_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/success_message/success_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/warning_message/warning_message.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/area_officer_master_local/area_officer_master_local.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_mobile_transaction/bloc_mobile_transaction_bloc.dart';
import 'package:logger/logger.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:sizer/sizer.dart';

class AreaOfficerQRScreen extends StatefulWidget {
  final Barcode? barcodeResult;
  const AreaOfficerQRScreen({Key? key, this.barcodeResult}) : super(key: key);

  @override
  _AreaOfficerQRScreenState createState() => _AreaOfficerQRScreenState();
}

class _AreaOfficerQRScreenState extends State<AreaOfficerQRScreen> {
  final currentUserBox = Hive.box('currentUser');
  final areaOfficerLocalBox = Hive.box('areaOfficerMasterLocal');

  bool isPaymentReceived = false;

  @override
  Widget build(BuildContext context) {
    var logger = Logger();

    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;

    Map<String, dynamic> qrData = jsonDecode(widget.barcodeResult!.code!);

    logger.i(qrData);

    AreaOfficerHelperModel areaOfficer = AreaOfficerHelperModel.fromJson(qrData);

    logger.i('scanned by donor' + areaOfficer.memberRemittanceMasterID.toString());

    String areaOfficerQR = '{'
        '\"amount\": ${areaOfficer.amount},'
        '\"referenceNumber\": \"${areaOfficer.referenceNumber}\",'
        '\"communityOfficeIdNumber\": \"${areaOfficer.communityOfficeIdNumber}\",'
        '\"memberRemittanceMasterID\": \"${areaOfficer.memberRemittanceMasterID}\",'
        '\"agentMemberId\": \"${currentUser.memberId}\",'
        '\"agentMemberName\": \"${currentUser.name}\"'
        '}';

    String confirmedAreaOfficerQR = '{'
        '\"amount\": ${areaOfficer.amount},'
        '\"referenceNumber\": \"${areaOfficer.referenceNumber}\",'
        '\"communityOfficeIdNumber\": \"${areaOfficer.communityOfficeIdNumber}\",'
        '\"memberRemittanceMasterID\": \"${areaOfficer.memberRemittanceMasterID}\",'
        '\"agentMemberId\": \"${currentUser.memberId}\",'
        '\"agentMemberName\": \"${currentUser.name}\",'
        '\"result\": \"true\"'
        '}';

    return Scaffold(
      // backgroundColor: kWebOrange,
      appBar: AppBar(
        leading: TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: const Text("Back")
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
            color: Colors.blue
        ),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    border: Border.all()
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: QrImage(
                    data: areaOfficerQR,
                    size: 200.0,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 5.0.h),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Please show this QR Code to the officer as proof of transaction.',
                      style: TextStyle(
                          color: Colors.red
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.0.h),
              Container(
                width: 90.0.w,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reference Number:",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 9.0.sp,
                            color: Colors.black
                        ),
                      ),
                      Text(
                        '${areaOfficer.referenceNumber}',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          fontSize: 12.0.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(
                        Radius.circular(8.0)
                    )
                ),
              ),
              SizedBox(height: 2.0.h),
              Container(
                width: 90.0.w,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Amount:",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 9.0.sp,
                            color: Colors.black
                        ),
                      ),
                      Text(
                        "${double.parse(areaOfficer.amount.toString()).toStringAsFixed(2)} pesos",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            fontSize: 12.0.sp
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(
                        Radius.circular(8.0)
                    )
                ),
              ),
              SizedBox(height: 2.0.h),
              SizedBox(
                width: 90.0.w,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(isPaymentReceived ? Colors.grey : Colors.green[900])),
                      onPressed: isPaymentReceived ? (){} : (){

                        List<Widget> textButtons = [
                          TextButton(
                              onPressed: () async {
                                var connectivityResult = await (Connectivity().checkConnectivity());
                                if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                                  AreaOfficerMasterLocal areaOfficerMasterLocal = AreaOfficerMasterLocal(
                                      amount: areaOfficer.amount.toString(),
                                      referenceNumber: areaOfficer.referenceNumber,
                                      communityOfficeId: areaOfficer.communityOfficeIdNumber,
                                      communityOfficerName: areaOfficer.communityOfficeName,
                                      communityOfficerMemberId: areaOfficer.communityOfficeMemberId,
                                      memberRemittanceMasterID: areaOfficer.memberRemittanceMasterID,
                                      agentMemberId: currentUser.memberId,
                                      status: 1,
                                      isAreaOfficer: true,
                                      creatorID: currentUser.memberId,
                                      dateCreated: DateTime.now().toString(),
                                      transactionType: TransactionType.transactionTypeRemittanceMaster[2]
                                  );

                                  areaOfficerLocalBox.add(areaOfficerMasterLocal);
                                  //TODO _updateCollectorAgentMasterRemittance(UpdateCollectorAgentMasterParams updateRemittanceMasterParams)

                                  UpdateCollectorAgentMasterParams updateCollectorAgentMasterParams =
                                  UpdateCollectorAgentMasterParams(
                                      masterRemittanceId: areaOfficerMasterLocal.memberRemittanceMasterID,
                                      collectorAgentId: currentUser.memberId
                                  );

                                  final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(context);
                                  mobileTransactionBloc.add(UpdateCollectorAgentMasterEvent(updateCollectorAgentMasterParams: updateCollectorAgentMasterParams));

                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => AlertDialog(
                                        title: Text('Generated ID:'),
                                        actions: [
                                          SizedBox(
                                            height: 60.h,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(5.0),
                                                        child: QrImage(
                                                          data: confirmedAreaOfficerQR,
                                                          size: 200.0,
                                                          foregroundColor: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 1.0.h),
                                                  Padding(
                                                    padding: const EdgeInsets.all(12.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: const [
                                                        Text(
                                                          'Please show this QR Code to the officer as proof of transaction.',
                                                          style: TextStyle(
                                                              color: Colors.red
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 1.0.h),
                                                  Container(
                                                    width: 90.0.w,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Reference Number:",
                                                            style: GoogleFonts.lato(
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 9.0.sp,
                                                                color: Colors.black
                                                            ),
                                                          ),
                                                          Text(
                                                            '${areaOfficer.referenceNumber}',
                                                            style: GoogleFonts.lato(
                                                              fontWeight: FontWeight.w900,
                                                              color: Colors.black,
                                                              fontSize: 12.0.sp,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    decoration: const BoxDecoration(
                                                        color: Colors.orange,
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(8.0)
                                                        )
                                                    ),
                                                  ),
                                                  SizedBox(height: 2.0.h),
                                                  Container(
                                                    width: 90.0.w,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Amount:",
                                                            style: GoogleFonts.lato(
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 9.0.sp,
                                                                color: Colors.black
                                                            ),
                                                          ),
                                                          Text(
                                                            "${double.parse(areaOfficer.amount.toString()).toStringAsFixed(2)} pesos",
                                                            style: GoogleFonts.lato(
                                                                fontWeight: FontWeight.w900,
                                                                color: Colors.black,
                                                                fontSize: 12.0.sp
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    decoration: const BoxDecoration(
                                                        color: Colors.orange,
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(8.0)
                                                        )
                                                    ),
                                                  ),
                                                  SizedBox(height: 2.0.h),
                                                  Container(
                                                    width: 90.0.w,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Name:",
                                                            style: GoogleFonts.lato(
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 9.0.sp,
                                                                color: Colors.black
                                                            ),
                                                          ),
                                                          Text(
                                                            "${areaOfficer.communityOfficeName}",
                                                            style: GoogleFonts.lato(
                                                                fontWeight: FontWeight.w900,
                                                                color: Colors.black,
                                                                fontSize: 12.0.sp
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    decoration: const BoxDecoration(
                                                        color: Colors.orange,
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(8.0)
                                                        )
                                                    ),
                                                  ),
                                                  SizedBox(height: 2.0.h),
                                                  Container(
                                                    width: 90.0.w,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "ID Number:",
                                                            style: GoogleFonts.lato(
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 9.0.sp,
                                                                color: Colors.black
                                                            ),
                                                          ),
                                                          Text(
                                                            "${areaOfficer.communityOfficeIdNumber}",
                                                            style: GoogleFonts.lato(
                                                                fontWeight: FontWeight.w900,
                                                                color: Colors.black,
                                                                fontSize: 12.0.sp
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    decoration: const BoxDecoration(
                                                        color: Colors.orange,
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(8.0)
                                                        )
                                                    ),
                                                  ),
                                                  SizedBox(height: 2.0.h),
                                                  TextButton(
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                        Navigator.of(context, rootNavigator: true).pop(context);
                                                      },
                                                      child: const Text('Close')
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                  );
                                  Navigator.pop(context);
                                } else {
                                  Navigator.pop(context);
                                  Navigator.of(context, rootNavigator: true).pop(context);
                                  showDialog(context: context, builder: (context) => const WarningMessage(title: "Warning", content: "No internet connection. Please try again later."));
                                }
                              },
                              child: const Text('Yes')
                          ),
                          TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                                Navigator.of(context, rootNavigator: true).pop(context);
                              },
                              child: const Text('No')
                          )
                        ];
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) =>
                            // SuccessMessage(
                            //   title: 'Success',
                            //   content: 'Successfully recorded donation!',
                            //   onPressedFunction: () {
                            //     //TODO: USE NAVIGATOR.POPUNTIL
                            //     Navigator.pop(context);
                            //   },
                            // )
                            ReminderMessage(title: "Confirmation.", content: "Did you receive Php ${areaOfficer.amount.toString()}0 donation from "
                                "${areaOfficer.communityOfficeName}", textButtons: textButtons, )
                        );

                        // setState(() {
                        //   isPaymentReceived = true;
                        //
                        //   const snackBar = SnackBar(
                        //     content: Text('Donation Master recorded!'),
                        //     duration: Duration(seconds: 5),
                        //   );
                        //
                        //   Future.delayed(const Duration(seconds: 0), () {
                        //     Navigator.pop(context);
                        //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        //   });
                        // });

                      },
                      child: Text(isPaymentReceived ? 'Donation is Recorded' : 'Record Master Donation')
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
