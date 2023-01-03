import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/reminder_message/reminder_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/scanned_qr/scanned_unremitted_donation_string/scanned_unremitted_donation_string.dart';
import 'package:kabrigadan_mobile/src/core/utils/uuid_generator/uuid_generator.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation/unremitted_donation.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation_ui/unremitted_donation_ui.dart';
import 'package:logger/logger.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

class ProfileAndCaseQRScreen extends StatefulWidget {
  final Barcode? barcodeResult;
  final VoidCallback? refresh;
  const ProfileAndCaseQRScreen(this.barcodeResult, {Key? key, this.refresh}) : super(key: key);

  @override
  State<ProfileAndCaseQRScreen> createState() => _ProfileAndCaseQRScreenState();
}

class _ProfileAndCaseQRScreenState extends State<ProfileAndCaseQRScreen> {
  final currentUserBox = Hive.box('currentUser');
  final unremittedDonationBox = Hive.box('unremittedDonations');
  final unremittedDonationUiBox = Hive.box('unremittedDonationsUi');

  bool isPaymentReceived = false;
  String temporaryId = '';
  String qrGetData = '';

  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    var uuid = const Uuid();

    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;

    Map<String, dynamic> qrData = jsonDecode(widget.barcodeResult!.code!);
    logger.i(qrData);
    ScannedUnremittedDonationString scannedUnremittedDonationString = ScannedUnremittedDonationString.fromJson(qrData);

    logger.i(scannedUnremittedDonationString);

    return Scaffold(
      // backgroundColor: kWebOrange,
      appBar: AppBar(
        leading: TextButton(
            onPressed: () {widget.refresh!(); Navigator.pop(context); },
            child: const Text("Back")
        ),
        title: const Text(
          "Donation of SAMPLE",
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
            color: Colors.blue
        ),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
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
                    data: widget.barcodeResult!.code!,
                    size: 200.0,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 5.0.h),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      "Donor's name:",
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w700,
                          fontSize: 11.0.sp,
                          color: Colors.black
                      ),
                    ),
                    Text(
                      '${scannedUnremittedDonationString.name}',
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w900,
                          fontSize: 15.0.sp,
                          color: Colors.black
                      ),
                    ),
                    Text(
                      '${scannedUnremittedDonationString.donatedByMemberIdNumber}',
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w700,
                          fontSize: 11.0.sp,
                          color: Colors.black
                      ),
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
                        "Amount:",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 9.0.sp,
                            color: Colors.black
                        ),
                      ),
                      Text(
                        "${double.parse(scannedUnremittedDonationString.amount!).toStringAsFixed(2)} pesos",
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
                        "Reference Code",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 9.0.sp,
                            color: Colors.black
                        ),
                      ),
                      Text(
                        '${scannedUnremittedDonationString.caseCode}',
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
              SizedBox(
                width: 90.0.w,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(isPaymentReceived ? Colors.grey : Colors.green[900])),
                      onPressed: isPaymentReceived ? (){} : () async {
                        String tempId = await UuidGenerator().generateUuid();

                        String qrData = "{"
                            "\"transactionId\": \"$tempId\","
                            "\"officerName\": \"${currentUser.name}\","
                            "\"officerIdNumber\": \"${currentUser.idNumber}\","
                            "\"donorIdNumber\": \"${scannedUnremittedDonationString.donatedByMemberIdNumber.toString()}\","
                            "\"amount\": \"${scannedUnremittedDonationString.amount.toString()}\""
                            "}";

                        List<Widget> textButtons = [
                          TextButton(
                              onPressed: (){
                                receivePayment(scannedUnremittedDonationString, currentUser, tempId, qrData, context);
                              },
                              child: const Text('Yes')
                          ),
                          TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: const Text('No')
                          )
                        ];
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => ReminderMessage(title: "Confirmation.", content: "Did you receive ${scannedUnremittedDonationString.amount.toString()} donation from "
                                "${scannedUnremittedDonationString.name.toString()}", textButtons:
                            textButtons)
                        );

                      },
                      child: Text(isPaymentReceived ? 'Donation is Received' : 'Donation Received')
                  ),
                ),
              ),
              isPaymentReceived ?
              TextButton(
                  onPressed: (){
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          title: const Text('Generated ID:'),
                          content: _qrForm(qrGetData, temporaryId, currentUser.name, scannedUnremittedDonationString.amount.toString()),
                          actions: [
                            TextButton(
                                onPressed: (){
                                  logger.i(qrGetData);
                                  Navigator.pop(context);
                                },
                                child: const Text('Close')
                            ),
                          ],
                        )
                    );
                  },
                  child: const Text('Show Generated ID')
              ) : const SizedBox(height: 0)
            ],
          ),
        ),
      ),
    );
  }

  void receivePayment(ScannedUnremittedDonationString scannedUnremittedDonationString, CurrentUser currentUser, String tempId, String qrData, BuildContext context) {
    UnremittedDonation unremittedDonation = UnremittedDonation(
        caseCode: scannedUnremittedDonationString.caseCode,
        amount: double.parse(scannedUnremittedDonationString.amount.toString()),
        donatedByMemberIdNumber: scannedUnremittedDonationString.donatedByMemberIdNumber,
        agentMemberIdNumber: currentUser.idNumber,
        status: 1,
        memberRemittanceMasterId: null,
        ayannahAttachment: null,
        unremittedTempId: tempId,
        id: null,
        creatorId: currentUser.memberId
    );

    UnremittedDonationUi unremittedDonationUi = UnremittedDonationUi(
        caseCode: scannedUnremittedDonationString.caseCode,
        amount: double.parse(scannedUnremittedDonationString.amount!),
        donatedByMemberIdNumber: scannedUnremittedDonationString.donatedByMemberIdNumber,
        agentMemberIdNumber: currentUser.idNumber,
        status: 1,
        memberRemittanceMasterId: null,
        ayannahAttachment: null,
        unremittedTempId: tempId,
        id: null,
        name: scannedUnremittedDonationString.name,
        dateRecorded: DateTime.now(),
        creatorId: currentUser.memberId
    );

    unremittedDonationBox.add(unremittedDonation);
    unremittedDonationUiBox.add(unremittedDonationUi);

    setState(() {
      isPaymentReceived = true;
      temporaryId = tempId;
      qrGetData = qrData;

      // const snackBar = SnackBar(
      //   behavior: SnackBarBehavior.floating,
      //   content: Text('Donation Received!'),
      //   duration: Duration(seconds: 5),
      // );

      // Future.delayed(const Duration(seconds: 0), () {
      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // });
    });
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Generated ID:'),
          content: _qrForm(qrData, tempId, currentUser.name, scannedUnremittedDonationString.amount.toString()),
          actions: [
            Flushbar(
              message: "Donation Received!",
              icon: Icon(
                Icons.info_outline,
                size: 28.0,
                color: Colors.blue[300],
              ),
              leftBarIndicatorColor: Colors.blue[300],
              isDismissible: true,
            ),
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Close')
            ),
          ],
        )
    );
  }

  Widget _qrForm(String qrData, String transactionId, String? officerName, String amount) {
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
                    data: qrData,
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
                      text: 'Please show this QR Code to the member as proof of transaction.',
                      style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                    ),
                  ]
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.0.h),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$transactionId\n',
                      style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: 'Transaction Id',
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
                      text: officerName != null ? '$officerName\n' : 'Officer Name\n',
                      style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: 'Officer Name',
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
          ],
        ),
      ),
    );
  }
}