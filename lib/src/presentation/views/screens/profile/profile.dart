import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/core/utils/context_holder/context_holder.dart';
import 'package:kabrigadan_mobile/src/core/utils/log_out/main_log_out.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/reminder_message/reminder_message.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_current_user/current_user_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_mobile_transaction/bloc_mobile_transaction_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/profile/current_user/profile_current_user.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/welcome_screen/welcome_screen.dart';
import 'package:sizer/sizer.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  double defFontSize = getDeviceType() == 'phone' ? 10.0.sp : 9.0.sp;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserBloc, CurrentUserState>(builder: (_, state) {
      if (state is GetCurrentUserDone) {
        return SafeArea(child: ProfileCurrentUser(currentUserEntity: state.currentUserEntity));
      }

      if (state is GetCurrentUserLoading) {
        return Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40.0, width: 40.0, child: CircularProgressIndicator()),
            Positioned.fill(

              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Log out of your account', style: GoogleFonts.lato(color: Colors.black)),
                      ),
                      Card(
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
                                    Navigator.pop(context);
                                  },
                                  child: const Text('No')
                              ),
                            ];

                            showDialog(context: context, builder: (context) => ReminderMessage(title: "Reminder", content: "Are you sure you want to log out?", textButtons: textButtons));
                          },
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: Text('Log Out', style: GoogleFonts.lato(color: Colors.red, fontSize: defFontSize)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
      }

      return const ProfileCurrentUser();
    });
  }

  Future<void> logOut(BuildContext context) async {
    MainLogOut().logOut(context);
    Navigator.pushAndRemoveUntil(ContextKeeper.buildContext, MaterialPageRoute(builder: (BuildContext context) => const Dashboard()), ModalRoute.withName('/'));
  }
}
