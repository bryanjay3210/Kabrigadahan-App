import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/core/utils/tenant_settings/brigadahan_funds_code.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/domain/entities/newsfeed/newsfeed.dart';
import 'package:kabrigadan_mobile/src/presentation/widgets/donation/qr_form.dart';
import 'package:kabrigadan_mobile/src/presentation/widgets/messages/payment_prompt.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

class DonateWithoutFundraising extends StatelessWidget {
  final NewsFeed? newsFeed;
  final CurrentUser? currentUser;

  const DonateWithoutFundraising({Key? key, this.newsFeed, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController amountOfDonation = TextEditingController();
    TextEditingController transactionIdController = TextEditingController();

    return GestureDetector(
      onTap: (){
        showDialog(context: context, builder: (context) => AlertDialog(
          title: newsFeed != null ? Text('Donate to ${newsFeed!.fundraisingItem!.fundRaising!.fundraising!.recipient!}') :
          const Text('Donate to KaBrigadahan Foundation'),
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
                        onPressed: (){
                          amountOfDonation.text = "5";
                        },
                        child: Text('Php 5', style: TextStyle(color: kPrimaryColor, fontSize: 10.0.sp)),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLight)),
                      ),
                      SizedBox(width: 5.0.sp),
                      TextButton(
                        onPressed: (){
                          amountOfDonation.text = "10";
                        },
                        child: Text('Php 10', style: TextStyle(color: kPrimaryColor, fontSize: 10.0.sp)),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLight)),
                      ),
                      SizedBox(width: 5.0.sp,),
                      TextButton(
                        onPressed: (){
                          amountOfDonation.text = "15";
                        },
                        child: Text('Php 15', style: TextStyle(color: kPrimaryColor, fontSize: 10.0.sp),),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLight)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: (){
                          amountOfDonation.text = "20";
                        },
                        child: Text('Php 20', style: TextStyle(color: kPrimaryColor, fontSize: 10.0.sp),),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLight)),
                      ),
                      SizedBox(width: 5.0.sp),
                      TextButton(
                        onPressed: (){
                          amountOfDonation.text = "50";
                        },
                        child: Text('Php 50', style: TextStyle(color: kPrimaryColor, fontSize: 10.0.sp)),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLight)),
                      ),
                      SizedBox(width: 5.0.sp),
                      TextButton(
                        onPressed: (){
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
                          Icons.money_rounded
                      ),
                      labelText: 'Amount',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  const SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                      onPressed: (){
                        //TODO: CASE CODE MUST BE FROM TENANT SETTINGS
                        String qrData = "{"
                            "\"donatedByMemberIdNumber\": \"${currentUser!.idNumber}\","
                            "\"name\": \"${currentUser!.name}\","
                            "\"amount\": \"${amountOfDonation.text}\","
                            "\"caseCode\": \"${BrigadahanFundsCode.brigadahanFundsCode}\""
                        "}";

                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Donate Now'),
                              content: QrForm(isCurrentUser: false, qrData: qrData, amount: amountOfDonation.text, referenceCode: BrigadahanFundsCode.brigadahanFundsCode.toString()),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      showCupertinoModalBottomSheet(
                                        context: context,
                                        builder: (context) => PaymentPrompt(caseCode: BrigadahanFundsCode.brigadahanFundsCode, isDonor: true),
                                      );
                                    },
                                    child: const Text('Record Donation'))
                              ],
                            ));

                        //TODO: REMOVE IF SHOW CUPERTINO MODAL IS OKAY
                        // showDialog(
                        //     context: context,
                        //     builder: (context) =>
                        //         AlertDialog(
                        //           title: const Text('Donate Now'),
                        //           content: QrForm(
                        //               isCurrentUser: false, qrData: qrData, amount: amountOfDonation.text, referenceCode: BrigadahanFundsCode.brigadahanFundsCode.toString()),
                        //           actions: [
                        //             TextButton(
                        //                 onPressed: () {
                        //                   showDialog(
                        //                       context: context,
                        //                       builder: (context) =>
                        //                           AlertDialog(
                        //                             title: const Text('Where did you pay your donation?'),
                        //                             actions: [
                        //                               TextButton(
                        //                                   onPressed: () {
                        //                                     showDialog(
                        //                                         context: context,
                        //                                         barrierDismissible: false,
                        //                                         builder: (context) =>
                        //                                             AlertDialog(
                        //                                               title: const Text('Thank you for your donation.'),
                        //                                               content: const Text('Please wait for 24 hours for us to process your donation.'),
                        //                                               actions: [
                        //                                                 TextButton(
                        //                                                     onPressed: () {
                        //                                                       //TODO: USE NAVIGATOR.POPUNTIL
                        //                                                       Navigator.pop(context);
                        //                                                       Navigator.pop(context);
                        //                                                       Navigator.pop(context);
                        //                                                       Navigator.pop(context);
                        //                                                     },
                        //                                                     child: const Text('Close'))
                        //                                               ],
                        //                                             ));
                        //                                   },
                        //                                   child: const Text('BrigadaPay')),
                        //                               TextButton(
                        //                                   onPressed: () {
                        //                                     showDialog(
                        //                                         context: context,
                        //                                         barrierDismissible: false,
                        //                                         builder: (context) => AlertDialog(
                        //                                           title: const Text('Camera Scan QR Code'),
                        //                                           content: SingleChildScrollView(
                        //                                             child: Column(
                        //                                               children: [
                        //                                                 const Text('Please scan the qr code generated by the officer as proof of transaction. Thank you!'),
                        //                                                 OutlinedButton(
                        //                                                     onPressed: () {
                        //                                                       Navigator.push(
                        //                                                           context,
                        //                                                           MaterialPageRoute(
                        //                                                               builder: (context) =>
                        //                                                                   ProfileAndCaseQRScanner(isDonorQrScanner: true, caseCode: BrigadahanFundsCode.brigadahanFundsCode)));
                        //                                                     },
                        //                                                     child: const Text('Scan QR Code'))
                        //                                               ],
                        //                                             ),
                        //                                           ),
                        //                                           actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                        //                                         ));
                        //                                   },
                        //                                   child: const Text('Kabrigadahan Officer'))
                        //                             ],
                        //                           ));
                        //                 },
                        //                 child: const Text('Record Donation'))
                        //           ],
                        //         ));
                      }, child: const Text('Donate Now')),
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: const Text('Close')
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset('assets/images/donate-kabrigadahan.png')
        ),
      ),
    );
  }
}
