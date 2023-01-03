import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/shims/dart_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/update_collector_agent_master/update_collector_agent_master.dart';
import 'package:kabrigadan_mobile/src/core/utils/area_officer_helper_model.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/core/utils/dropdown_data/dropdown_data.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/error_message/error_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/reminder_message/reminder_message.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/area_officer_master_local/area_officer_master_local.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation/unremitted_donation_reference.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_mobile_transaction/bloc_mobile_transaction_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/collection_form/collection_form_main.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/qr_scanner/screen/area_officer_qr_screen.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/qr_scanner/screen/donor_case_qr_screen.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/qr_scanner/screen/profile_and_case_qr_screem.dart';
import 'package:logger/logger.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sizer/sizer.dart';

class ProfileAndCaseQRScanner extends StatefulWidget {
  final bool? isDonorQrScanner;
  final String? caseCode;
  final bool? isCollectionForm;
  final VoidCallback? refresh;
  final bool? isAreaOfficer;

  ///PARAMETERS FROM BODY COLLECTION FORM
  final bool? isConnected;

  final bool? isCOScanningAreaOfficer;
  final AreaOfficerMasterLocal? areaOfficerMasterLocal;

  const ProfileAndCaseQRScanner({Key? key, this.isDonorQrScanner, this.caseCode, this.isCollectionForm, this.isConnected, this.isAreaOfficer, this.refresh, this.isCOScanningAreaOfficer, this.areaOfficerMasterLocal}) : super(key: key);

  @override
  _ProfileAndCaseQRScannerState createState() => _ProfileAndCaseQRScannerState();
}

class _ProfileAndCaseQRScannerState extends State<ProfileAndCaseQRScanner> {
  var logger = Logger();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 250.0 : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(borderColor: Colors.red, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
    );
  }

  Future<bool> isQrError(String resultCode, List<String> list) async {
    int count = 0;
    for(String i in list){
      if(resultCode.contains(i)){
        count = count + 1;
      }
    }

    return count == list.length ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    var logger = Logger();

    if (result != null) {
      controller!.stopCamera();

      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async {
        if(widget.isDonorQrScanner != null){
          ///IF DONOR IS SCANNING
          if(widget.isDonorQrScanner!){
            String? resultCode = result!.code;
            List<String> codeFormat = ["transactionId", "officerName", "officerIdNumber" , "donorIdNumber", "amount"];

            bool isError = await isQrError(resultCode!, codeFormat);

            !isError ? Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (currentContext) => DonorCaseQrScreen(barcodeResult: result, caseCode: widget.caseCode))
            ) : showDialog(
                context: context,
                useRootNavigator: false,
                builder: (context) => ErrorMessage(title: "Error", content: "Invalid QR Code", onPressedFunction: (){
                  //TODO: TEST NAVIGATOR POPPING FURTHER
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (currentContext) => const AuthScreen())
                  // );
                  Navigator.pop(context);
                  Navigator.pop(context);
                })
            );
          }
          ///IF CO IS SCANNING
          else {
            String? resultCode = result!.code;
            List<String> codeFormat = ["donatedByMemberIdNumber", "name", "amount", "caseCode"];

            bool isError = await isQrError(resultCode!, codeFormat);

            if(isError){
              ///AREA OFFICER MIGHT BE THE ONE SCANNING
              List<String> areaOfficerCodeFormat = ["amount", "referenceNumber", "communityOfficeIdNumber", "memberRemittanceMasterID"];

              bool isErrorCheck = await isQrError(resultCode, areaOfficerCodeFormat);

              if(isErrorCheck){
                showDialog(
                    context: context,
                    useRootNavigator: false,
                    builder: (context) => ErrorMessage(title: "Error", content: "Invalid QR Code", onPressedFunction: (){
                      //TODO: TEST THE NAVIGATOR POPPING FURTHER
                      Navigator.pop(context);
                      Navigator.pop(context);
                    })
                );
              } else {
                logger.i(result);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (currentContext) => AreaOfficerQRScreen(barcodeResult: result)));
              }
            } else{
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (currentContext) => ProfileAndCaseQRScreen(result, refresh: widget.refresh)));
            }
          }
        } else {
          List<Map<String, dynamic>> mapMember = DropdownData.mapMember;

          ///IF FROM COLLECTION FORM
          if(widget.isCollectionForm != null){
            if(widget.isCollectionForm!){
              if('-'.allMatches(result!.code.toString()).length == 1){
                bool isBrigadahanId = false;

              var member = mapMember.firstWhere((e) => e['cityQrCodeId'].toString() == result!.code.toString().trim().replaceAll(' ', ''), orElse: () => {});
              if(member.isEmpty){

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CollectionFormMain(isConnected: widget.isConnected!, barcode: result, isBrigadahanId: isBrigadahanId, isMember: false)));
                // showDialog(
                //     context: context,
                //     useRootNavigator: false,
                //     builder: (context) => ErrorMessage(title: "Invalid QR Code.", content: "You are not allowed to collect donation from members not under your list.", onPressedFunction: (){
                //       //TODO: TEST THE NAVIGATOR POPPING FURTHER
                //       Navigator.pop(context);
                //       Navigator.pop(context);
                //     })
                // );
              }
              else{
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CollectionFormMain(isConnected: widget.isConnected!, barcode: result, isBrigadahanId: isBrigadahanId, isMember: true,)));
              }

            }
            else if('-'.allMatches(result!.code.toString()).length == 2){
              var res = result;
              bool isBrigadahanId = true;
              var member = mapMember.firstWhere((e) => e['memberId'].toString() == result!.code.toString().trim().replaceAll(' ', ''), orElse: () => {});
              if(member.isEmpty){
                String? idNumber = result!.code.toString();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CollectionFormMain(isConnected: widget.isConnected!, barcode: result, isBrigadahanId: isBrigadahanId, isMember: false, idNumber: idNumber,)));
                // showDialog(
                //     context: context,
                //     useRootNavigator: false,
                //     builder: (context) => ErrorMessage(title: "Invalid QR Code", content: "You are not allowed to collect donation from members not under your list.", onPressedFunction: (){
                //       //TODO: TEST THE NAVIGATOR POPPING FURTHER
                //       Navigator.pop(context);
                //       Navigator.pop(context);
                //     })
                // );
              } else{
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CollectionFormMain(isConnected: widget.isConnected!, barcode: result, isBrigadahanId: isBrigadahanId, isMember: true,)));
              }

              } else {
                showDialog(
                    context: context,
                    useRootNavigator: false,
                    builder: (context) => ErrorMessage(title: "Error", content: "Invalid QR Code", onPressedFunction: (){
                      //TODO: TEST THE NAVIGATOR POPPING FURTHER
                      Navigator.pop(context);
                      Navigator.pop(context);
                    })
                );
              }
            }
          } else {
            if(widget.isCOScanningAreaOfficer != null){
              if(widget.isCOScanningAreaOfficer!){
                ///IF CO IS REMITTING TO AREA OFFICER
                String? resultCode = result!.code;
                List<String> coRemitAOCodeFormat = ["amount", "referenceNumber", "communityOfficeIdNumber", "memberRemittanceMasterID", "agentMemberId", "result"];

                bool isErrorCheck = await isQrError(resultCode!, coRemitAOCodeFormat);

                if(isErrorCheck) {
                  showDialog(
                    context: context,
                    builder: (context) => ErrorMessage(title: "Error", content: "Invalid QR Code", onPressedFunction: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    })
                  );
                } else {
                  Map<String, dynamic> resultJsonCode = jsonDecode(resultCode);
                  AreaOfficerHelperModel areaOfficerHelperModel = AreaOfficerHelperModel.fromJson(resultJsonCode);

                  List<Widget> textButtons = [
                    TextButton(
                      onPressed: () async{
                        final areaOfficerBoxLocal = Hive.box('areaOfficerMasterLocal');
                        final unremittedDonationBox = Hive.box('unremittedDonations');
                        final unremittedDonationUiBox = Hive.box('unremittedDonationsUi');
                        final unremittedDonationReferenceBox = Hive.box('unremittedDonationReference');

                        widget.areaOfficerMasterLocal!.agentMemberId = areaOfficerHelperModel.agentMemberId;
                        areaOfficerBoxLocal.add(widget.areaOfficerMasterLocal!);

                        /// UPDATE COLLECTOR AGENT MASTER REMITTANCE
                        UpdateCollectorAgentMasterParams updateCollectorAgentMasterParams =
                          UpdateCollectorAgentMasterParams(
                            masterRemittanceId: widget.areaOfficerMasterLocal!.memberRemittanceMasterID,
                            collectorAgentId: areaOfficerHelperModel.agentMemberId
                          );

                        final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(context);
                        mobileTransactionBloc.add(UpdateCollectorAgentMasterEvent(updateCollectorAgentMasterParams: updateCollectorAgentMasterParams));

                        /// Save reference in local if don't have a internet
                        var connectivityResult = await (Connectivity().checkConnectivity());
                        if (connectivityResult != ConnectivityResult.mobile || connectivityResult != ConnectivityResult.wifi) {
                          UnremittedDonationReference unremittedDonationReference = UnremittedDonationReference(
                              referenceNumber: widget.areaOfficerMasterLocal!.memberRemittanceMasterID,
                              memberRemittanceMasterId: widget.areaOfficerMasterLocal!.memberRemittanceMasterID,
                              transactionType: 'Kabrigadahan Officer',
                              collectorAgentId: areaOfficerHelperModel.agentMemberId
                          );
                          unremittedDonationReferenceBox.add(unremittedDonationReference);
                        }

                        unremittedDonationBox.clear();
                        unremittedDonationUiBox.clear();

                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Yes')
                    ),
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('No')
                    )
                  ];

                  showDialog(
                    context: context,
                    builder: (context) => ReminderMessage(title: "Confirmation", content: "Are you sure it was received by ${areaOfficerHelperModel.agentMemberName}?", textButtons:
                    textButtons)
                  );
                }
              }
            }
          }
        }
      });
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Back"),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: kChipColor),
        ),
        backgroundColor: kBackgroundColor,
        body: Column(
          children: [
            Expanded(flex: 4, child: _buildQrView(context)),
            Container(
              width: 80.0.w,
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0))),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 1.5.h,
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
                              onPressed: () async {
                                await controller?.toggleFlash();
                                setState(() {});
                              },
                              child: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  return Text(
                                    "Flash",
                                    style: GoogleFonts.lato(fontSize: 0.5.h, color: Colors.white),
                                  );
                                },
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
