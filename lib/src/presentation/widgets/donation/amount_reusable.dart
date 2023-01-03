import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/warning_message/warning_message.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/domain/entities/newsfeed/newsfeed.dart';
import 'package:kabrigadan_mobile/src/presentation/widgets/donation/qr_form.dart';
import 'package:kabrigadan_mobile/src/presentation/widgets/messages/payment_prompt.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

class AmountReusable extends StatefulWidget {
  final NewsFeed? newsFeed;
  final CurrentUser currentUser;

  const AmountReusable({Key? key, this.newsFeed, required this.currentUser}) : super(key: key);

  @override
  _AmountReusableState createState() => _AmountReusableState();
}

class _AmountReusableState extends State<AmountReusable> {
  final myUnremittedDonationsBox = Hive.box('myUnremittedDonations');
  final currentUserBox = Hive.box('currentUser');

  TextEditingController amountOfDonation = TextEditingController();
  TextEditingController transactionIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(height: 5.0),
        OutlinedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: widget.newsFeed != null ? Text('Donate to ${widget.newsFeed!.fundraisingItem!.fundRaising!.fundraising!.recipient!}') : const Text('Donate to current user'),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      amountOfDonation.text = "5";
                                    },
                                    child: Text('Php 5', style: TextStyle(color: kPrimaryColor, fontSize: 10.0.sp)),
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLight)),
                                  ),
                                  SizedBox(
                                    width: 5.0.sp,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      amountOfDonation.text = "10";
                                    },
                                    child: Text('Php 10', style: TextStyle(color: kPrimaryColor, fontSize: 10.0.sp)),
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLight)),
                                  ),
                                  SizedBox(
                                    width: 5.0.sp,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      amountOfDonation.text = "15";
                                    },
                                    child: Text(
                                      'Php 15',
                                      style: TextStyle(color: kPrimaryColor , fontSize: 10.0.sp),
                                    ),
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLight)),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      amountOfDonation.text = "20";
                                    },
                                    child: Text(
                                      'Php 20',
                                      style: TextStyle(color: kPrimaryColor , fontSize: 10.0.sp),
                                    ),
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLight)),
                                  ),
                                  SizedBox(
                                    width: 5.0.sp,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      amountOfDonation.text = "50";
                                    },
                                    child: Text('Php 50', style: TextStyle(color: kPrimaryColor, fontSize: 10.0.sp)),
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLight)),
                                  ),
                                  SizedBox(
                                    width: 5.0.sp,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      amountOfDonation.text = "100";
                                    },
                                    child: Text('Php 100', style: TextStyle(color: kPrimaryColor, fontSize: 10.0.sp)),
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLight)),
                                  ),
                                ],
                              ),
                              TextFormField(
                                controller: amountOfDonation,
                                decoration: const InputDecoration(
                                  icon: Icon(
                                    Icons.money_rounded,
                                    color: Colors.blue,
                                  ),
                                  labelText: 'Amount',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],
                                style: const TextStyle(color: kPrimaryColor),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        donateNow(context, amountOfDonation);
                                      },
                                      child: const Text('Donate Now')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Close'))
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ));

            // Navigator.pop(context);
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
              backgroundColor: MaterialStateProperty.all(kPrimaryLight),
              side: MaterialStateProperty.all(const BorderSide(color: kPrimaryLight, width: 1.0))),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
            child: Text(
              'Donate',
              style: TextStyle(
                color: Color(0xe6ff0000),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void donateNow(BuildContext context, TextEditingController amountOfDonation) {
    String qrData = "{"
        "\"donatedByMemberIdNumber\": \"${widget.currentUser.idNumber}\","
        "\"name\": \"${widget.currentUser.name}\","
        "\"amount\": \"${amountOfDonation.text}\","
        "\"caseCode\": \"${widget.newsFeed!.fundraisingItem!.fundRaising!.fundraising!.caseCode}\""
        "}";

    if (amountOfDonation.text.isNotEmpty) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Donate Now'),
                content: QrForm(isCurrentUser: false, qrData: qrData, amount: amountOfDonation.text, referenceCode: widget.newsFeed!.fundraisingItem!.fundRaising!.fundraising!.caseCode!),
                actions: [
                  TextButton(
                      onPressed: () {
                        showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) => PaymentPrompt(caseCode: widget.newsFeed!.fundraisingItem!.fundRaising!.fundraising!.caseCode, isDonor: true),
                        );
                      },
                      child: const Text('Record Donation'))
                ],
              ));
    } else {
      showDialog(
        context: context,
        builder: (context) => const WarningMessage(title: "Warning.", content: "Please input a valid amount.")
      );
    }
  }
}
