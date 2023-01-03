import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/auth/login/body/body_login.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
          icon: Icons.person,
          backgroundColor: kPrimaryColor,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.app_registration, color: Colors.white,),
              label: 'Register Now!',
              backgroundColor: kPrimaryColor,
              onTap: () async {
                try {
                  await launch("$kBaseUrl/account/register");
                } on Exception {
                  throw 'Could not launch "$kBaseUrl/account/register"';
                }
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.supervised_user_circle, color: Colors.white,),
              label: 'Retrieved Membership',
              backgroundColor: kPrimaryColor,
              onTap: () async {
                try {
                  await launch("$kBaseUrl/account/retrieve-membership");
                } on Exception {
                  throw 'Could not launch "$kBaseUrl/account/retrieve-membership"';
                }
              },
            ),
          ]),
      body: const Padding(
        padding: EdgeInsets.all(30.0),
        child: BodyLogin(),
      ),
    );
  }
}
