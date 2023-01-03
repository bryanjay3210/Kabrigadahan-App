import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/update_master_remittance_ayannah/update_master_remittance_ayannah_params.dart';
import 'package:kabrigadan_mobile/src/core/utils/enums/trasaction_type/transaction_type.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/reminder_message/reminder_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/success_message/success_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/warning_message/warning_message.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/area_officer_master_local/area_officer_master_local.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/remitted_donation/remitted_donation.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation/unremitted_donation_reference.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_mobile_transaction/bloc_mobile_transaction_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/qr_scanner/profile_and_case_qr_scanner.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/transaction_attachment_display/transaction_attachment_display.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

class PaymentPrompt extends StatelessWidget {
  final String? caseCode;
  final bool isDonor;

  ///Parameters coming from CO
  final CameraDescription? camera;
  final CurrentUser? currentUser;
  final List<RemittedDonation>? toBeRemittedList;
  final String? qrData;
  final CurrentUser? communityOfficer;

  ///Parameters from QR
  final double? amount;
  final String? referenceNumber;
  final String? masterRemittanceId;
  final int? status;
  final VoidCallback? refresh;
  const PaymentPrompt({Key? key, this.caseCode, required this.isDonor, this.toBeRemittedList, this.currentUser, this.camera, this.qrData, this.masterRemittanceId, this.communityOfficer, this.amount, this.referenceNumber, this.status, this.refresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: Center(child: Text('Where did you remit your collection?')),
              ),
              ListTile(
                title: const Text('BrigadaPay'),
                leading: const Icon(CupertinoIcons.money_rubl_circle),
                onTap: (){
                  if(!isDonor){
                    List<Widget> textButtons = [
                      TextButton(
                          onPressed: () async{
                            final areaOfficerLocalBox = Hive.box('areaOfficerMasterLocal');
                            final unremittedDonationBox = Hive.box('unremittedDonations');
                            final unremittedDonationUiBox = Hive.box('unremittedDonationsUi');
                            final myUnremittedDonationRemittanceBox = Hive.box('myUnremittedDonationRemittance');
                            final unremittedDonationReferenceBox = Hive.box('unremittedDonationReference');

                            AreaOfficerMasterLocal areaOfficerMaster = AreaOfficerMasterLocal(
                                amount: amount.toString(),
                                referenceNumber: referenceNumber,
                                communityOfficeId: currentUser!.idNumber,
                                communityOfficerName: currentUser!.name,
                                communityOfficerMemberId: currentUser!.memberId,
                                memberRemittanceMasterID: masterRemittanceId,
                                status: 1,
                                isAreaOfficer: false,
                                agentMemberId: null,
                                creatorID: currentUser!.memberId,
                                dateCreated: DateTime.now().toString(),
                                transactionType: "BrigadaPay"
                            );
                            areaOfficerLocalBox.add(areaOfficerMaster);
                            unremittedDonationBox.clear();
                            unremittedDonationUiBox.clear();


                            UpdateMasterRemittanceAyannahParams updateMasterRemittanceAyannahParams = UpdateMasterRemittanceAyannahParams(
                              masterRemittanceId: masterRemittanceId,
                              receiptFileAttachment: null,
                              transactionId: null
                            );

                            final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(context);
                            mobileTransactionBloc.add(UpdateMasterRemittanceAyannahEvent(updateMasterRemittanceAyannahParams: updateMasterRemittanceAyannahParams));

                            /// Save reference in local if don't have a internet
                            var connectivityResult = await (Connectivity().checkConnectivity());
                            if (connectivityResult != ConnectivityResult.mobile || connectivityResult != ConnectivityResult.wifi) {
                              UnremittedDonationReference unremittedDonationReference = UnremittedDonationReference(
                                  referenceNumber: referenceNumber,
                                  memberRemittanceMasterId: masterRemittanceId,
                                  transactionType: 'Ayannah'
                              );
                              unremittedDonationReferenceBox.add(unremittedDonationReference);
                            }

                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                    SuccessMessage(
                                      title: 'Thank you for your donation!',
                                      content: 'Please wait for 24 hours for us to process your donation.',
                                      onPressedFunction: () {
                                        //TODO: USE NAVIGATOR.POPUNTIL
                                        // final mobileBloc = BlocProvider.of<MobileTransactionBloc>(context);
                                        // mobileBloc.add(const PromptTrigger());
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        refresh!();
                                      },
                                    ));
                          },
                          child: const Text("Yes")
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text("No")
                      ),
                    ];

                    showDialog(
                        context: context,
                        builder: (context) => ReminderMessage(title: "Please confirm.", content: "Did you pay the donations to BrigadaPay?", textButtons: textButtons)
                    );
                  } else {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          title: const Text('Thank you for your donation!'),
                          content: const Text('Please wait for 24 hours for us to process your donation.'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  //TODO: USE NAVIGATOR.POPUNTIL
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  refresh!();
                                },
                                child: const Text('Close'))
                          ],
                        ));
                  }
                },
              ),
              ListTile(
                title: const Text('Kabrigadahan Officer'),
                leading: const Icon(CupertinoIcons.person_2),
                onTap: (){
                  if(isDonor){
                    donorReceivePayment(context);
                  } else{
                    List<Widget> textButtons = [
                      TextButton(
                        onPressed: () async{
                          AreaOfficerMasterLocal areaOfficerMasterLocal = AreaOfficerMasterLocal(
                              amount: amount.toString(),
                              referenceNumber: referenceNumber,
                              communityOfficeId: currentUser!.idNumber,
                              communityOfficerName: currentUser!.name,
                              communityOfficerMemberId: currentUser!.memberId,
                              memberRemittanceMasterID: masterRemittanceId,
                              status: 1,
                              isAreaOfficer: true,
                              agentMemberId: null,
                              creatorID: currentUser!.memberId,
                              dateCreated: DateTime.now().toString(),
                              transactionType: TransactionType.transactionTypeRemittanceMaster[2]
                          );

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                                  title: const Text('Camera Scan QR Code'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const Text('Please scan the qr code generated by the officer as proof of transaction. Thank you!'),
                                        OutlinedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ProfileAndCaseQRScanner(
                                                        isCOScanningAreaOfficer: true,
                                                        areaOfficerMasterLocal: areaOfficerMasterLocal
                                                      )
                                                  )
                                              );
                                            },
                                            child: const Text('Scan QR Code'))
                                      ],
                                    ),
                                  ),
                                  actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                                ));
                        },
                        child: const Text("Yes")
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text("No")
                      ),
                    ];

                    showDialog(
                      context: context,
                      builder: (context) => ReminderMessage(title: "Confirmation.", content: "Did you remit your collection to KaBrigadahan Officer?", textButtons: textButtons)
                    );
                  }
                },
              ),
            ],
          ),
        ));
  }

  void donorReceivePayment(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Camera Scan QR Code'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Please scan the qr code generated by the officer as proof of transaction. Thank you!'),
                OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileAndCaseQRScanner(
                                  isDonorQrScanner: true,
                                  caseCode: caseCode)));
                    },
                    child: const Text('Scan QR Code'))
              ],
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
        ));
  }

  void coPaymentReceived(BuildContext context, String areaOfficerQR){
    TextEditingController transactionIdController = TextEditingController();

    //TODO: FOR UPDATING REMITTANCE MASTER WITHOUT CAMERA
    // showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: const Text('Input Id.'),
    //       content: SingleChildScrollView(
    //         child: Column(
    //           children: [
    //             const Text('Please input the id generated by your Community Officer here.'),
    //             TextFormField(
    //               controller: transactionIdController,
    //               decoration: const InputDecoration(
    //                 icon: Icon(Icons.perm_identity),
    //                 labelText: 'Transaction Id',
    //               ),
    //             ),
    //             const SizedBox(height: 20.0),
    //             const Text('Attachment receipt, if any:'),
    //             OutlinedButton(
    //                 onPressed: () {
    //                   pushAttachmentDisplay(context, transactionIdController);
    //                 },
    //                 child: const Text('Open Camera'))
    //           ],
    //         ),
    //       ),
    //       actions: [
    //         TextButton(
    //             onPressed: transactionIdController.text.isEmpty ? (){
    //               showDialog(
    //                   context: context,
    //                   builder: (context) => const WarningMessage(title: "Warning.", content: "Transaction Id is required.")
    //               );
    //             } : () {
    //               final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(context);
    //
    //               mobileTransactionBloc.add(UpdateRemittanceMasterEvent(
    //                 context, toBeRemittedList!,
    //                     (){
    //                   //TODO: USE POPUNTIL
    //                   Navigator.pop(context);
    //                   Navigator.pop(context);
    //                   Navigator.pop(context);
    //                   Navigator.pop(context);
    //                   Navigator.pop(context);
    //                 },
    //
    //                 updateRemittanceMasterParams: UpdateRemittanceMasterParams(
    //                   referenceNumber: UnremittedDonations.referenceNumber,
    //                   transactionId: transactionIdController.text,
    //                   transactionSourceType: 1,
    //                   communityOfficerAgentId: currentUser!.memberId,
    //                   receiptFileAttachment: null,
    //                 ),
    //               ));
    //             },
    //             child: const Text('Save'))
    //       ],
    //     ));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remit your collection'),
        content: _qrFormAO(areaOfficerQR),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Ok')
          )
        ],
      )
    );
  }

  Widget _qrFormAO(String areaOfficerQR){
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
                      text: '$masterRemittanceId\n',
                      style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: 'Member Remittance Master ID',
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
                      text: 'Php ${double.parse(amount.toString()).toStringAsFixed(2)}\n',
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
                      text: '${currentUser!.name}\n',
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
                      text: '${currentUser!.memberId}\n',
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

  void pushAttachmentDisplay(BuildContext context, TextEditingController transactionIdController) {
    if(transactionIdController.text.isNotEmpty){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TransactionAttachmentDisplay(
                camera: camera!,
                currentUser: currentUser!,
                transactionId: transactionIdController.text,
                toBeRemittedList: toBeRemittedList!,
              )));
    } else {
      showDialog(
          context: context,
          builder: (context) => const WarningMessage(title: 'Warning!', content: "Please enter a valid Transaction ID before proceeding.")
      );
    }
  }
}


