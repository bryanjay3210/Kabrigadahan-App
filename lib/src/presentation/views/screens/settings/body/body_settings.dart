import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kabrigadan_mobile/src/core/utils/context_holder/context_holder.dart';
import 'package:kabrigadan_mobile/src/core/utils/log_out/main_log_out.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_mobile_transaction/bloc_mobile_transaction_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/welcome_screen/welcome_screen.dart';
import 'package:sizer/sizer.dart';

class BodySettings extends StatefulWidget {
  const BodySettings({Key? key}) : super(key: key);

  @override
  _BodySettingsState createState() => _BodySettingsState();
}

class _BodySettingsState extends State<BodySettings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 5.0.h),
              _buildLogout(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(){
    return Container(
      width: 100.0.w,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.orange[100],
                radius: 48.0,
                child: Image.asset('assets/images/kabrigadahan-icon.png'),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  text: 'Kabrigadahan Mobile',
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w900
                  )
                ),
                textAlign: TextAlign.center,
              )
            ),
            Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                      text: 'version: 1.0.0',
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 10.0.sp,
                          fontWeight: FontWeight.w300
                      )
                  ),
                  textAlign: TextAlign.center,
                )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLogout(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Log out of your account',style: GoogleFonts.lato(color: Colors.black, fontSize: 12.0.sp)),
        ),
        Card(
          color: Colors.white,
          child: ListTile(
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Are you sure you want to log out?"),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        final timeBloc = BlocProvider.of<MobileTransactionBloc>(context);
                        timeBloc.timer!.cancel();
                        await logOut(context);
                      },
                      child: const Text('Log Out')
                    ),
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Text('No')
                    )
                  ],
                )
              );
            },
            leading: const Icon(CupertinoIcons.delete, color: Colors.red),
            title: Text('Log Out', style: GoogleFonts.lato(color: Colors.red)),
          ),
        ),
      ],
    );
  }

  Future<void> logOut(BuildContext context) async {
    MainLogOut().logOut(context);
    Navigator.pushAndRemoveUntil(
        ContextKeeper.buildContext,
        MaterialPageRoute(builder: (BuildContext context) => const Dashboard()),
        ModalRoute.withName('/')
    );

    // pushNewScreen(
    //   context,
    //   screen: const Dashboard(),
    //   withNavBar: false,
    //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
    // );
  }
}
