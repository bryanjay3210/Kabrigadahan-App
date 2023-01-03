import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabrigadan_mobile/src/core/utils/login/login.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_auth/auth_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_fundraising/fundraising_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/authenticated_init_views/member_authenticated_init_view/member_authenticated_init_view.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/authenticated_init_views/community_officer_authenticated_init_view/init_view.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/unathenticated/unauthenticated_init_view.dart';
import 'package:logger/logger.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    final fundraisingBloc = BlocProvider.of<FundraisingBloc>(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (_, state){
        if(state is Unauthenticated){
          fundraisingBloc.add(const GetFundraising());
          return const Scaffold(
            body: UnauthenticatedInitView(),
          );
        }

        if(state is MemberAuthenticated){
          LoginFunction().loginAddEventsToBloc(context);
          FundraisingBloc.skipCount = 0;
          return const Scaffold(
            body: MemberAuthenticatedInitView(),
          );
        }

        if(state is CommunityOfficerAuthenticated){
          LoginFunction().loginAddEventsToBloc(context);
          FundraisingBloc.skipCount = 0;

          return const Scaffold(
            body: CommunityOfficerAuthenticatedInitView(),
          );
        }

        if(state is AuthError){
          return const Scaffold(
            body: UnauthenticatedInitView(),
          );
        }
        return const SizedBox(width: 0);
      },
    );
  }
}
