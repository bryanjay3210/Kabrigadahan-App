import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/error_message/error_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/success_message/success_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/scanned_qr/scanned_by_donor_qr/scanned_by_donor_qr.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/my_unremitted_donation/my_unremitted_donation.dart';
import 'package:logger/logger.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

class DonorCaseQrScreen extends StatefulWidget {
  final Barcode? barcodeResult;
  final String? caseCode;
  const DonorCaseQrScreen({Key? key, this.barcodeResult, this.caseCode}) : super(key: key);

  @override
  _DonorCaseQrScreenState createState() => _DonorCaseQrScreenState();
}

class _DonorCaseQrScreenState extends State<DonorCaseQrScreen> {
  final myUnremittedDonationsBox = Hive.box('myUnremittedDonations');
  final currentUserBox = Hive.box('currentUser');

  bool isPaymentReceived = false;

  @override
  Widget build(BuildContext context) {
    var logger = Logger();

    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;
    Map<String, dynamic> qrData = jsonDecode(widget.barcodeResult!.code!);
    logger.i(qrData);

    ScannedByDonor scannedByDonor = ScannedByDonor.fromJson(qrData);

    logger.i('Donor IdNumber: ' + scannedByDonor.donorIdNumber.toString());
    logger.i('Current IdNumber: ' + currentUser.idNumber.toString());

    return
      scannedByDonor.donorIdNumber.toString() == currentUser.idNumber.toString() ?
      Scaffold(
      // backgroundColor: kWebOrange,
      appBar: AppBar(
        leading: TextButton(
            onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
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
                      '${currentUser.name}',
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w900,
                          fontSize: 15.0.sp,
                          color: Colors.black
                      ),
                    ),
                    Text(
                      '${currentUser.idNumber}',
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
                        "${double.parse(scannedByDonor.amount!).toStringAsFixed(2)} pesos",
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
                        "Transaction Id",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 9.0.sp,
                            color: Colors.black
                        ),
                      ),
                      Text(
                        '${scannedByDonor.transactionId}',
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
                        "Community Officer Name",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 9.0.sp,
                            color: Colors.black
                        ),
                      ),
                      Text(
                        '${scannedByDonor.officerName}',
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
                      onPressed: isPaymentReceived ? (){} : (){
                        MyUnremittedDonation myUnremittedDonation =
                        MyUnremittedDonation(
                            caseCode: widget.caseCode,
                            amount: double.parse(scannedByDonor.amount.toString()),
                            donatedByMemberIdNumber: currentUser.idNumber,
                            agentMemberIdNumber: scannedByDonor.officerIdNumber,
                            status: 1,
                            memberRemittanceMasterId: null,
                            ayannahAttachment: null,
                            unremittedTempId: scannedByDonor.transactionId,
                            id: null,
                            name: currentUser.name,
                            dateRecorded: DateTime.now(),
                            creatorId: currentUser.memberId
                        );

                        myUnremittedDonationsBox.add(myUnremittedDonation);

                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) =>
                                SuccessMessage(
                                  title: 'Success',
                                  content: 'Successfully recorded donation!',
                                  onPressedFunction: () {
                                    //TODO: USE NAVIGATOR.POPUNTIL
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ));

                        setState(() {
                          isPaymentReceived = true;

                          const snackBar = SnackBar(
                            content: Text('Donation recorded!'),
                            duration: Duration(seconds: 5),
                          );

                          Future.delayed(const Duration(seconds: 0), () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        });

                      },
                      child: Text(isPaymentReceived ? 'Donation is Recorded' : 'Record Donation')
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ) :  ErrorMessage(title: "Invalid QR Code", content: "Donor does not match!", onPressedFunction: (){
    //TODO: TEST THE NAVIGATOR POPPING FURTHER
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    });
  }
}
