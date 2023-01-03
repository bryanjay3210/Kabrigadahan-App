import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kabrigadan_mobile/src/core/params/auth/auth_params.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/error_message/error_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/warning_message/warning_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/store_preferences.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_auth/auth_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_fundraising/fundraising_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_tenant_settings/bloc_tenant_settings_bloc.dart';
import 'package:sizer/sizer.dart';

class BodyLogin extends StatefulWidget {
  const BodyLogin({Key? key}) : super(key: key);

  @override
  _BodyLoginState createState() => _BodyLoginState();
}

class _BodyLoginState extends State<BodyLogin> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _hidePassword = true;

  void _hidePass() {
    setState(() {
      if (_hidePassword) {
        _hidePassword = false;
      } else {
        _hidePassword = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
      child: SizedBox(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/brigadahanLogo.png",
              height: 20.0.h,
            ),
            const SizedBox(
              height: 5.0,
            ),
            SizedBox(
              // color: Colors.red,
              height: 10.0.h,
              width: 100.0.w,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Log In',
                  style: GoogleFonts.lato(
                    fontSize: 6.0.w,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 30.0.h,
              width: 100.0.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextFormField(
                    controller: userNameController,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.face), labelText: 'Username'),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        userNameController.clear();
                        return 'Username is empty';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // ignore: deprecated_member_use
                    // inputFormatters: [BlacklistingTextInputFormatter(RegExp(r"\s\b|\b\s"))],
                    inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))],
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.vpn_key_outlined),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.remove_red_eye),
                          onPressed: _hidePass,
                        )),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        passwordController.clear();
                        return 'Password is empty';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // ignore: deprecated_member_use
                    // inputFormatters: [BlacklistingTextInputFormatter(RegExp(r"\s\b|\b\s"))],
                    inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))],
                    obscureText: _hidePassword,
                  ),
                  BlocListener<AuthBloc, AuthState>(
                    listener: (_, state) {
                      // if (state.error != null) {
                        try{
                          if (state.error!.response!.statusCode! <= 599 && state.error!.response!.statusCode! >= 400) {
                            authBloc.isLoading = false;

                            showDialog(context: context, builder: (context) => ErrorMessage(title: "Error", content: "Invalid username or password", onPressedFunction: () => Navigator.pop(context)));

                            setState(() {});
                          }
                        }catch(_){
                          authBloc.isLoading = false;
                          // showDialog(context: context, builder: (context) => ErrorMessage(title: "Error", content: "No Internet Please Try again later.", onPressedFunction: () => Navigator.pop(context)));
                          setState(() {});
                        }
                        BlocListener<TenantSettingsBloc, TenantSettingsState>(
                          listener: (_, state2){
                            if(state2.error == null){
                              authBloc.isLoading = false;
                              showDialog(context: context, builder: (context) => ErrorMessage(title: "Error", content: "No Internet Please Try again later.", onPressedFunction: () => Navigator.pop(context)));
                              setState(() {});
                            }
                          },
                        );
                      // }
                    },
                    child: authBloc.isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red[700],
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 2.0.h),
                            ),
                            onPressed: () {
                              var connectivityResult = Connectivity().checkConnectivity();

                              connectivityResult.then((value) async {
                                var isConnected = value == ConnectivityResult.mobile || value == ConnectivityResult.wifi ? true : false;

                                if (isConnected) {
                                  final authBloc = BlocProvider.of<AuthBloc>(context);
                                  final fundraisingBloc = BlocProvider.of<FundraisingBloc>(context);
                                  final tenantSettingsBloc = BlocProvider.of<TenantSettingsBloc>(context);

                                  await StorePreferences().storeIsOfficer(false);

                                  fundraisingBloc.add(const LoadFundraising());
                                  authBloc.add(
                                      LoginEvent(params: AuthParams(userNameOrEmailAddress: userNameController.text, password: passwordController.text, isOfficerOnMemberApp: false)));
                                  tenantSettingsBloc.add(const GetTenantSettingsEvent());

                                  WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {}));
                                  authBloc.isLoading = true;

                                } else {
                                  showDialog(context: context, builder: (context) => const WarningMessage(title: "Warning.", content: "No Internet Connection."));
                                }
                              });
                            },
                            child: const Text('Log in')),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
