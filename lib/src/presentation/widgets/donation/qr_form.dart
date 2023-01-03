import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

class QrForm extends StatefulWidget {
  final bool isCurrentUser;
  final String qrData;
  final String amount;
  final String referenceCode;

  const QrForm({Key? key, required this.isCurrentUser, required this.qrData, required this.amount, required this.referenceCode}) : super(key: key);

  @override
  _QrFormState createState() => _QrFormState();
}

class _QrFormState extends State<QrForm> {
  final currentUserBox = Hive.box('currentUser');

  @override
  Widget build(BuildContext context) {
    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;

    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 150,
                width: 150,
                child: Center(
                  child: QrImage(
                    data: widget.qrData,
                    size: 150.0,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
            ),
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
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${currentUser.idNumber}\n',
                      style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: 'ID Number:',
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
                      text: '${widget.referenceCode}\n',
                      style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: 'Reference Code',
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
                      text: 'Php ${double.parse(widget.amount).toStringAsFixed(2)}\n',
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
