import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kabrigadan_mobile/src/config/routes/app_routes.dart';
import 'package:kabrigadan_mobile/src/config/themes/app_theme.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/area_officer_master/area_officer_master.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/area_officer_master_local/area_officer_master_local.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/members_under_co.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/my_unremitted_donation/my_unremitted_donation.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/my_unremitted_donation/my_unremitted_donation_remittance.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/remitted_donation/remitted_donation.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation/unremitted_donation.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation/unremitted_donation_bulk_remit.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation/unremitted_donation_reference.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation_ui/unremitted_donation_ui.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/area_officer_master-in_progress/area_officer_master_in_progress.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation_ui_server/unremitted_donation_ui_server.dart';
import 'package:kabrigadan_mobile/src/injector.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_auth/auth_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_current_user/bloc_members_under_co/members_under_co_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_current_user/current_user_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_donations/donations_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_donations/sync_donations_bloc/sync_donations_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_fundraising/fundraising_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_mobile_transaction/bloc_mobile_transaction_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_mobile_transaction/bloc_mobile_transaction_update/mobile_transaction_update_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_mobile_version/bloc_mobile_version_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_my_recent_search/my_recent_search_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_tenant_settings/bloc_tenant_settings_bloc.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/my_recent_search/my_recent_search.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation/unremitted_donation_fromserver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:path_provider/path_provider.dart' as path_provider;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );

  await GlobalConfiguration().loadFromAsset("appsettings");
  await initializeDependencies();

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(CurrentUserAdapter());
  Hive.registerAdapter(UnremittedDonationAdapter());
  Hive.registerAdapter(UnremittedDonationUiAdapter());
  Hive.registerAdapter(RemittedDonationAdapter());
  Hive.registerAdapter(MembersUnderCOAdapter());
  Hive.registerAdapter(MyUnremittedDonationAdapter());
  Hive.registerAdapter(MyRecentSearchAdapter());
  Hive.registerAdapter(AreaOfficerMasterAdapter());
  Hive.registerAdapter(UnremittedDonationFromServerAdapter());
  Hive.registerAdapter(AreaOfficerMasterLocalAdapter());
  Hive.registerAdapter(AreaOfficerMasterInProgressAdapter());
  Hive.registerAdapter(UnremittedDonationUiServerAdapter());
  Hive.registerAdapter(MyUnremittedDonationRemittanceAdapter());
  Hive.registerAdapter(UnremittedDonationReferenceAdapter());
  Hive.registerAdapter(UnremittedDonationBulkRemitAdapter());

  // runApp(const MyApp());
  HydratedBlocOverrides.runZoned(
        () => runApp(const MyApp()),
    storage: storage,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Future<void> _openBox() async {
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
  }

  @override
  void initState() {
    _openBox();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FundraisingBloc>(
          create: (_) => injector()..add(const GetFundraising())
        ),
        BlocProvider<AuthBloc>(
          create: (_) => injector()..add(GetAuthentication(context))
        ),
        BlocProvider<CurrentUserBloc>(
          create: (_) => injector()..add(const GetCurrentUserEvent())
        ),
        BlocProvider<DonationsBloc>(
          create: (_) => injector()..add(const GetDonationsEvent())
        ),
        BlocProvider<MobileTransactionBloc>(
          create: (_) => injector()..add(const SendingMobileTransactionEvent())
        ),
        // BlocProvider<MobileTransactionBloc>(
        //     create: (_) => injector()..add(const GetCurrentUserRemittanceMasterEvent())
        // ),
        BlocProvider<TenantSettingsBloc>(
          create: (_) => injector()..add(const GetTenantSettingsEvent())
        ),
        BlocProvider<MyRecentSearchBloc>(
            create: (_) => injector()..add(const GetMyRecentSearch())
        ),
        BlocProvider<MembersUnderCoBloc>(
            create: (_) => injector()..add(const GetMembersUnderCoEvent())
        ),
        BlocProvider<MobileVersionBloc>(
            create: (_) => injector()..add(const GetMobileVersionEvent())
        ),
        BlocProvider<MobileTransactionUpdateBloc>(
            create: (_) => injector()..add(const MobileTransactionInitialEvent())
        ),
        BlocProvider<SyncDonationsBloc>(
            create: (_) => injector()..add(const PostSyncDonationsDonorEvent())
        ),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: kMaterialAppTitle,
            onGenerateRoute: AppRoutes.onGenerateRoutes,
            theme: AppTheme.light,
          );
        }
      )
    );
  }
}
