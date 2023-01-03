import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/core/utils/context_holder/context_holder.dart';
import 'package:kabrigadan_mobile/src/core/utils/log_out/main_log_out.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/reminder_message/reminder_message.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/domain/entities/current_user/current_user_entity.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_current_user/current_user_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_mobile_transaction/bloc_mobile_transaction_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/welcome_screen/welcome_screen.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

class ProfileCurrentUser extends StatefulWidget {
  final CurrentUserEntity? currentUserEntity;

  const ProfileCurrentUser({Key? key, this.currentUserEntity}) : super(key: key);

  @override
  _ProfileCurrentUserState createState() => _ProfileCurrentUserState();
}

class _ProfileCurrentUserState extends State<ProfileCurrentUser> {
  double defFontSize = getDeviceType() == 'phone' ? 10.0.sp : 9.0.sp;
  var logger = Logger();
  String locallySave = '';
  final DateFormat formatter = DateFormat('MMM dd, yyyy');
  Image profilePicture = Image.asset("assets/images/avatar-person.png");

  final currentUserBox = Hive.box('currentUser');

  Future<void> _createFileFromString(String profBase64, String userID) async {
    final encodedStr = profBase64;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/" + userID + ".png");
    if (!file.existsSync()) {
      Uint8List bytes = base64.decode(encodedStr);
      await file.writeAsBytes(bytes);
    }
    locallySave = file.path;
  }

  Future<void> paths(String userID) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/" + userID + ".png");
    locallySave = file.path;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double profileHeight = 144;

    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;
    String? profPic = currentUser.profilepicture;

    String skipThis = "data:image/png;base64,";
    String base64resource = profPic != null ? profPic.substring(skipThis.length) : 'empty';

    logger.i("widget is " + widget.currentUserEntity.toString());

    return widget.currentUserEntity != null
        ? SingleChildScrollView(
            child: Container(
              // color: kBackgroundColor,
              color: Colors.white,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    child: Image.asset('assets/images/background/multicolored-paper-background_23-2148182446.jpg', fit: BoxFit.fill,),
                    height: 150,
                    width: width,
                  ),
                  BlocBuilder<CurrentUserBloc, CurrentUserState>(
                      builder: (context, state){
                        if(state is GetCurrentUserDone){
                          return  Column(
                            children: [
                              const SizedBox(height: 80.0),
                              Align(
                                alignment: Alignment.topCenter,
                                child: ClipOval(
                                  child: Container(
                                    height: 120,
                                    width: 120,
                                    color: kPastelRed,
                                    child: FutureBuilder(
                                        future: _createFileFromString(base64resource, currentUser.idNumber ?? ''),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.done) {
                                            return base64resource != 'empty' ? Image.file(File(locallySave)) : Image.asset('assets/images/kabrigadahan-icon.png');
                                          }
                                          return Container();
                                        }),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return const CircularProgressIndicator();
                      }
                  ),
                  BlocBuilder<CurrentUserBloc, CurrentUserState>(builder: (context, state) {
                    if (state is GetCurrentUserDone){
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(15, 220, 15, 110),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.currentUserEntity!.name!,
                                        style: GoogleFonts.lato(fontWeight: FontWeight.w900, fontSize: 15.0.sp),),
                                      const SizedBox(height: 10.0),
                                      RichText(text: TextSpan(
                                          children: [
                                            TextSpan(text: "Barangay ", style: GoogleFonts.lato(color: Colors.black, fontSize: defFontSize)),
                                            TextSpan(text: widget.currentUserEntity!.barangay, style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black, fontSize: defFontSize))
                                          ]
                                      )),
                                      const SizedBox(height: 5.0),
                                      RichText(text: TextSpan(
                                          children: [
                                            TextSpan(text: "Purok ", style: GoogleFonts.lato(color: Colors.black, fontSize: defFontSize)),
                                            TextSpan(text: widget.currentUserEntity!.purok, style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black, fontSize: defFontSize))
                                          ]
                                      )),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 10.0, bottom: 4.0, left: 20.0, right: 20.0),
                                        child: Divider(thickness: 1.0)),
                                      Text(
                                        "Id Number:",
                                        style: GoogleFonts.lato(fontWeight: FontWeight.w600,
                                            fontSize: 2.0.h),),
                                      Text(
                                        widget.currentUserEntity!.idNumber!,
                                        style: GoogleFonts.lato(fontWeight: FontWeight.w600, color: kPastelRed, fontSize: 2.0.h),
                                      ),
                                      QrImage(
                                        data: widget.currentUserEntity!.idNumber!,
                                        size: 20.0.h,),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 10.0, bottom: 4.0, left: 20.0, right: 20.0),
                                        child: Divider(thickness: 1.0)),
                                      Text(
                                          "Contact info",
                                          style: GoogleFonts.lato(fontWeight: FontWeight.w700, fontSize: 2.5.h)),
                                      const SizedBox(height: 10.0),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Row(
                                                children: [
                                                  const Icon(Icons.phone,size: 18.0,color: Colors.grey,),
                                                  const SizedBox(width: 5.0),
                                                  Text(
                                                    widget.currentUserEntity!.mobileNumber!,
                                                    style: GoogleFonts.lato(fontWeight: FontWeight.w300, fontSize: 2.0.h),)
                                                ]
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                          "Birthday",
                                          style: GoogleFonts.lato(fontWeight: FontWeight.w700, fontSize: 2.5.h)),
                                      const SizedBox(height: 10.0),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Row(
                                                children: [
                                                  const Icon(Icons.cake,size: 18.0,color: Colors.grey,),
                                                  const SizedBox(width: 5.0),
                                                  Text(
                                                    formatter.format(DateTime.parse(widget.currentUserEntity!.birthDate!)).toString(),
                                                    style: GoogleFonts.lato(fontWeight: FontWeight.w300, fontSize: 2.0.h),)
                                                ]
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                          "Assigned Officer",
                                          style: GoogleFonts.lato(fontWeight: FontWeight.w700, fontSize: 2.5.h)
                                      ),
                                      const SizedBox(height: 10.0),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Row(
                                                children: [
                                                  const Icon(Icons.person,size: 18.0,color: Colors.grey,),
                                                  const SizedBox(width: 5.0),
                                                  Text(
                                                    widget.currentUserEntity!.assignedOfficer!,
                                                    style: GoogleFonts.lato(fontWeight: FontWeight.w300, fontSize: 2.0.h),)
                                                ]
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 10.0, bottom: 4.0, left: 20.0, right: 20.0),
                                        child: Divider(thickness: 1.0),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }
                    return const CircularProgressIndicator();
                  }),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                        color: Colors.white,
                        height: 100,
                        width: width,
                        child: Column(
                          children: [
                            Text('Log out your account?', style: GoogleFonts.lato(color: Colors.black, fontSize: 12.0.sp)),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: SizedBox(
                                width: 80.0.w,
                                child: Card(
                                  color: kPrimaryLight,
                                  child: ListTile(
                                    onTap: () async {
                                      List<Widget> textButtons = [
                                        TextButton(
                                            onPressed: () async {
                                              final timeBloc = BlocProvider.of<MobileTransactionBloc>(context);
                                              if(timeBloc.timer != null){
                                                timeBloc.timer!.cancel();
                                              }
                                              await logOut(context);
                                            },
                                            child: const Text('Log Out')
                                        ),
                                        TextButton(
                                            onPressed: () async {
                                              Navigator.of(context, rootNavigator: true).pop(context);
                                            },
                                            child: const Text('No')
                                        ),
                                      ];

                                      showDialog(
                                          context: context,
                                          builder: (context) => ReminderMessage(title: "Reminder", content: "Are you sure you want to log out?", textButtons: textButtons));
                                    },
                                    leading: const Icon(Icons.logout, color: Colors.red),
                                    title: Text('Log Out', style: GoogleFonts.lato(color: Colors.red, fontSize: 12.0.sp)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          )
        : Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Admin',
                style: GoogleFonts.lato(
                  fontSize: 30.0.sp,
                  fontWeight: FontWeight.w900
                ),
              ),
              SizedBox(height: 4.0.h),
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.all(getDeviceType() == 'phone' ? 7.0 : 20.0),
                    child: Text('Log out of your account', style: GoogleFonts.lato(color: Colors.black, fontSize: 12.0.sp)),
                  ),
                  Card(
                    color: Colors.green,
                    child: ListTile(
                      onTap: () async {
                        List<Widget> textButtons = [
                          TextButton(
                              onPressed: () async {
                                final timeBloc = BlocProvider.of<MobileTransactionBloc>(context);
                                timeBloc.timer!.cancel();if(timeBloc.timer != null){
                                  timeBloc.timer!.cancel();
                                }
                                await logOut(context);
                              },
                              child: const Text('Log Out')
                          ),
                          TextButton(
                              onPressed: () async {
                                Navigator.of(context, rootNavigator: true).pop(context);
                              },
                              child: const Text('No')
                          ),
                        ];

                        showDialog(
                            context: context,
                            builder: (context) => ReminderMessage(title: "Reminder", content: "Are you sure you want to log out?", textButtons: textButtons));
                      },
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: Text('Log Out', style: GoogleFonts.lato(color: Colors.red)),
                    ),
                  ),
                ],
              )
            ],
          ),
        );

    // return FutureBuilder(
    //     future: _createFileFromString(base64resource, currentUser.idNumber ?? ''),
    //     builder: (context, snapshot){
    //       if(snapshot.connectionState == ConnectionState.done){
    //         return Image.file(File(locallySave)) ?? Image.asset('assets/images/kabrigadahan-icon.png');
    //       }
    //       return Container();
    //     }),
  }

  Future<void> logOut(BuildContext context) async {
    MainLogOut().logOut(context);
    Navigator.pushAndRemoveUntil(ContextKeeper.buildContext, MaterialPageRoute(builder: (BuildContext context) => const Dashboard()), ModalRoute.withName('/'));
  }
}
