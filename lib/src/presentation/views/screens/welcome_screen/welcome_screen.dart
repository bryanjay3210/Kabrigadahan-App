import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kabrigadan_mobile/src/core/utils/context_holder/context_holder.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/get_preferences.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/splash/splash_screen.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/welcome_screen/body_welcome.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    ContextKeeper().keepContext(context);

    return FutureBuilder(
        future: SharedPreferencesManager().isFreshInstalled(),
        builder: (context, isFreshInstalledSnapshot) {
          if(isFreshInstalledSnapshot.hasData){
            bool isFresh = isFreshInstalledSnapshot.data as bool;
            if(isFresh){
              return const SplashScreen();
            }
            else{
              return WillPopScope(
                onWillPop: () => onBackPressed(),
                child: const Scaffold(
                  backgroundColor: Colors.white,
                  resizeToAvoidBottomInset: false,
                  body: BodyWelcome(),
                ),
              );
            }
          }
          else{
            return const Scaffold();
          }
        }
    );

  }

  onBackPressed() {
    SystemNavigator.pop();
  }
}
