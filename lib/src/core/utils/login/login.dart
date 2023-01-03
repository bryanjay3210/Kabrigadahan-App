import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_current_user/bloc_members_under_co/members_under_co_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_current_user/current_user_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_donations/donations_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_fundraising/fundraising_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_mobile_transaction/bloc_mobile_transaction_bloc.dart';

class LoginFunction{
  Future<void> loginAddEventsToBloc(BuildContext context) async {
    int count =0;
    await Hive.openBox('currentUser');
    await Hive.openBox('memberListCO');
    await Hive.openBox('unremittedDonations');
    await Hive.openBox('unremittedDonationsUi');
    await Hive.openBox('remittedDonations');
    await Hive.openBox('myUnremittedDonations');
    await Hive.openBox('myRecentSearch');
    await Hive.openBox('areaOfficerMaster');
    await Hive.openBox('unremittedDonationsFromServer');
    await Hive.openBox('areaOfficerMasterLocal');
    await Hive.openBox('areaOfficerMasterInProgress');
    await Hive.openBox('unremittedDonationUiServer');
    await Hive.openBox('myUnremittedDonationRemittance');
    await Hive.openBox('unremittedDonationReference');
    await Hive.openBox('unremittedDonationBulkRemit');
    ///UPON LOGIN, ADD EVENTS TO BLOC
    ///
    final fundraisingBloc = BlocProvider.of<FundraisingBloc>(context);
    final currentUserBloc = BlocProvider.of<CurrentUserBloc>(context);
    final donationsBloc = BlocProvider.of<DonationsBloc>(context);
    final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(context);

    currentUserBloc.add(const GetCurrentUserEvent());
    fundraisingBloc.add(const GetFundraising());
    donationsBloc.add(const GetDonationsEvent());
    mobileTransactionBloc.add(const GetCurrentUserRemittanceMasterEvent());
    await Future.delayed(const Duration(seconds: 60),()async{
      if(mobileTransactionBloc.timer != null){
        mobileTransactionBloc.timer!.cancel();
      }
      mobileTransactionBloc.timer = Timer.periodic(const Duration(seconds: 30), (timer) async{
          ///TODO add API call for update
          /// Sync data
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
          if(mobileTransactionBloc.timerDone){
            late MobileTransactionBloc mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(context);
            mobileTransactionBloc.add(SyncUnremittedDonationEvent(context));
            mobileTransactionBloc.add(const SyncUnremittedDonationCOEvent());
          }
        }
        debugPrint('Refresh Count : ' + count.toString());
        count++;
      });
    });
  }
}