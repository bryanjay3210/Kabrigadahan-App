import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/reminder_message/reminder_message.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/remitted_donation/remitted_donation.dart';
import 'package:kabrigadan_mobile/src/presentation/widgets/messages/payment_prompt.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrAyannah extends StatefulWidget {
  final String? amount;
  final String? referenceNumber;
  final CameraDescription camera;
  final CurrentUser currentUser;
  final List<RemittedDonation> toBeRemittedList;
  final String? masterRemittanceId;

  const QrAyannah({Key? key, this.amount, this.referenceNumber, required this.camera, required this.currentUser, required this.toBeRemittedList, this.masterRemittanceId}) : super(key: key);

  @override
  _QrAyannahState createState() => _QrAyannahState();
}

class _QrAyannahState extends State<QrAyannah> {
  final currentUserBox = Hive.box('currentUser');
  final remittedDonationBox = Hive.box('remittedDonations');

  TextEditingController transactionIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;

    String ayannahQR = '{'
        '\"amount\": ${widget.amount},'
        '\"referenceNumber\": \"${widget.referenceNumber}\",'
        '\"communityOfficeIdNumber\": \"${currentUser.memberId}\"'
        '}';

    return AlertDialog(
      content: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            children: [
              QrImage(data: ayannahQR),
              const SizedBox(height: 20.0),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Php ${double.parse(widget.amount!).toStringAsFixed(2)}\n',
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
              const SizedBox(height: 20.0),
              RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${widget.referenceNumber}\n',
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
              const SizedBox(height: 20.0),
              RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${currentUser.name}\n',
                          style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                        ),
                        TextSpan(
                          text: 'Community Officer',
                          style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w500),
                        )
                      ]
                  ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              List<Widget> textButtons = [
                TextButton(
                    onPressed: () {
                      showCupertinoModalBottomSheet(
                        context: context,
                        builder: (context) => PaymentPrompt(isDonor: false, camera: widget.camera, currentUser: widget.currentUser, toBeRemittedList: widget.toBeRemittedList, qrData: ayannahQR,
                          masterRemittanceId: widget.masterRemittanceId, communityOfficer: currentUser),
                      );
                    },
                    child: const Text('Yes')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No')),
              ];

              showDialog(context: context, builder: (context) => ReminderMessage(title: "Reminder.", content: "Are you sure you want to remit?", textButtons: textButtons));
            },
            child: const Text('Donation Received'))
      ],
    );
  }
}
