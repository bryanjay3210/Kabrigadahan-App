import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/delete_preferences.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_auth/auth_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_current_user/bloc_members_under_co/members_under_co_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_current_user/current_user_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_donations/donations_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_fundraising/fundraising_bloc.dart';

class MainLogOut{
  Future<void> logOut(BuildContext context) async {
    ///PLEASE LIST ALL BLOCS HERE THAT NEEDED LOADING
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final fundraisingBloc = BlocProvider.of<FundraisingBloc>(context);
    final currentUserBloc = BlocProvider.of<CurrentUserBloc>(context);
    final donationsBloc = BlocProvider.of<DonationsBloc>(context);

    authBloc.add(const Logout());
    fundraisingBloc.add(const LoadFundraising());
    currentUserBloc.add(const LoadCurrentUser());
    donationsBloc.add(const DonationsLoadingEvent());

    ///DELETE PREFERENCES
    await DeletePreferences().deleteAccessToken();
    await DeletePreferences().deleteUserId();

    ///DELETE HIVE BOX CONTENTS
    final currentUserBox = Hive.box('currentUser');
    currentUserBox.clear();
    final membersUnderCOBox = Hive.box('membersUnderCO');
    membersUnderCOBox.clear();

    ///RESET SKIPCOUNT
    FundraisingBloc.skipCount = 0;
  }
}