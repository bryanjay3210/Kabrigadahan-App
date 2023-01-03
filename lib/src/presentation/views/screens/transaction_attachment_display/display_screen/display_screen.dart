import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kabrigadan_mobile/src/core/unremitted_donation/unremitted_donation.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/remitted_donation/remitted_donation.dart';
import 'package:logger/logger.dart';
import 'package:sizer/sizer.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final CurrentUser currentUser;
  final String bytes;
  final String transactionId;
  final List<RemittedDonation> toBeRemittedList;

  const DisplayPictureScreen({Key? key, required this.imagePath, required this.currentUser, required this.bytes, required this.transactionId, required this.toBeRemittedList}) : super(key: key);

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Receipt Photo',
          style: GoogleFonts.lato(
              color: Colors.black
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 90.0.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50.0.h,
                  child: Image.file(File(widget.imagePath)),
                ),
                SizedBox(height: 5.0.h),
                Card(
                    child: ListTile(
                      leading: const Icon(Icons.fingerprint),
                      title: Text(
                        UnremittedDonations.referenceNumber.toString()
                      ),
                      subtitle: const Text('Reference Number'),
                    )),
                SizedBox(height: 1.0.h),
                Card(
                    child: ListTile(
                      leading: const Icon(Icons.fingerprint),
                      title: Text(
                          widget.transactionId
                      ),
                      subtitle: const Text(
                          'Transaction ID'
                      ),
                    )),
                SizedBox(height: 1.0.h),
                Card(
                    child: ListTile(
                      leading: const Icon(Icons.fingerprint),
                      title: Text(
                          widget.currentUser.name!
                      ),
                      subtitle: const Text(
                          'Community Officer'
                      ),
                    )),
                SizedBox(height: 2.0.h),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                  'Reminders:'
                              ),
                              content: const Text(
                                  'Please check that the captured receipt is clear and readable.\n\n'
                                      'Please also check if the Transaction ID is correct.'
                              ),
                              actions: [
                                OutlinedButton(
                                    onPressed: (){
                                      // final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(context);
                                      //
                                      // String createUnremitted = '{'
                                      //     '"referenceNumber": \"${UnremittedDonations.referenceNumber}\",'
                                      //     '"transactionSourceType": 1,'
                                      //     '"communityOfficerAgentId": \"${widget.currentUser.memberId}\",'
                                      //     '"receiptFileAttachment": \"${widget.bytes}\"'
                                      //     '}';
                                      //
                                      // mobileTransactionBloc.add(
                                      //   UpdateRemittanceMasterEvent(
                                      //     context,
                                      //     widget.toBeRemittedList,
                                      //     (){
                                      //       //TODO: USE POPUNTIL
                                      //       Navigator.pop(context);
                                      //       Navigator.pop(context);
                                      //       Navigator.pop(context);
                                      //       Navigator.pop(context);
                                      //       Navigator.pop(context);
                                      //       Navigator.pop(context);
                                      //       Navigator.pop(context);
                                      //       Navigator.pop(context);
                                      //     },
                                      //     updateRemittanceMasterParams: UpdateRemittanceMasterParams(
                                      //       referenceNumber: UnremittedDonations.referenceNumber,
                                      //       transactionId: widget.transactionId,
                                      //       transactionSourceType: 1,
                                      //       communityOfficerAgentId: widget.currentUser.memberId,
                                      //       receiptFileAttachment: widget.bytes
                                      //     )));
                                      //
                                      // logger.i(createUnremitted);
                                      // Hive.box('unremittedDonationsUi').clear();
                                    },
                                    child: const Text(
                                        'Proceed'
                                    )
                                ),
                                TextButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Check again')
                                )
                              ],
                            )
                        );
                      },
                      child: const Text(
                        'Record Data'
                      )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
