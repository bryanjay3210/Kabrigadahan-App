import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:kabrigadan_mobile/src/data/datasources/remote/auth/auth_api_service.dart';
import 'package:kabrigadan_mobile/src/data/datasources/remote/current_user/current_user_api_service.dart';
import 'package:kabrigadan_mobile/src/data/datasources/remote/donations/donations_api_service.dart';
import 'package:kabrigadan_mobile/src/data/datasources/remote/fundraising/fundraising_api_service.dart';
import 'package:kabrigadan_mobile/src/data/datasources/remote/mobile_transaction/mobile_transaction_api_service.dart';
import 'package:kabrigadan_mobile/src/data/datasources/remote/tenant_settings/tenant_settings_api_service.dart';
import 'package:kabrigadan_mobile/src/data/repositories/current_user_impl/current_user_repository_impl.dart';
import 'package:kabrigadan_mobile/src/data/repositories/current_user_impl/members_under_co_impl.dart';
import 'package:kabrigadan_mobile/src/data/repositories/donations_repo_impl/donations_repository_impl.dart';
import 'package:kabrigadan_mobile/src/data/repositories/fundraising_repo_impl/fundraising_repository_impl.dart';
import 'package:kabrigadan_mobile/src/data/repositories/mobile_transaction_impl/mobile_transaction_repository_impl.dart';
import 'package:kabrigadan_mobile/src/data/repositories/tenant_settings_repo_impl/tenant_settings_repo_impl.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/auth/auth_repository.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/current_user/current_user_profile_picture_repository.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/current_user/current_user_repository.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/donations/donations_repository.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/fundraising/fundraising_repository.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/mobile_transaction/mobile_transaction_repository.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/tenant_settings/tenant_settings_repository.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/auth/auth_usecase.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/current_user/current_user_usecase.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/current_user/profile_picture.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/donations/donations_usecase.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/fundraising/fundraising_usecase.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/fundraising/total_count.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/fundraising_attachment/fundraising_attachment_use_case.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/mobile_transaction/mobile_transaction_use_case.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/tenant_settings/tenant_settings_use_case.dart';
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
import 'package:kabrigadan_mobile/src/data/datasources/remote/mobile_app_update/mobile_app_update_api_service.dart';
import 'data/repositories/auth_repo_impl/auth_repo_impl.dart';
import 'data/repositories/current_user_impl/current_user_profile_picture_repository_impl.dart';
import 'data/repositories/mobile_version_impl/mobile_version_impl.dart';
import 'domain/repositories/mobile_version/mobile_version_repository.dart';
import 'domain/usecases/current_user/members_under_co_usecase.dart';
import 'domain/usecases/mobile_version/mobile_version_use_case.dart';

final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  injector.registerSingleton<Dio>(Dio());

  ///API SERVICE
  injector.registerSingleton<AuthApiService>(AuthApiService(injector()));
  injector.registerSingleton<FundraisingApiService>(FundraisingApiService(injector()));
  injector.registerSingleton<CurrentUserApiService>(CurrentUserApiService(injector()));
  injector.registerSingleton<DonationsApiService>(DonationsApiService(injector()));
  injector.registerSingleton<MobileTransactionApiService>(MobileTransactionApiService(injector()));
  injector.registerSingleton<TenantSettingsApiService>(TenantSettingsApiService(injector()));
  injector.registerSingleton<MobileVersionApiService>(MobileVersionApiService(injector()));

  ///BLOC
  injector.registerFactory<FundraisingBloc>(() => FundraisingBloc(injector(), injector(), injector()));
  injector.registerFactory<AuthBloc>(() => AuthBloc(injector(), injector(), injector()));
  injector.registerFactory<CurrentUserBloc>(() => CurrentUserBloc(injector(), injector(), injector()));
  injector.registerFactory<DonationsBloc>(() => DonationsBloc(injector(), injector()));
  injector.registerFactory<MobileTransactionBloc>(() => MobileTransactionBloc(injector(), injector(), injector(), injector(), injector(), injector(), injector(), injector(), injector(), injector(), injector() ,injector(), injector()));
  injector.registerFactory<TenantSettingsBloc>(() => TenantSettingsBloc(injector()));
  injector.registerFactory<MyRecentSearchBloc>(() => MyRecentSearchBloc());
  injector.registerFactory<MembersUnderCoBloc>(() => MembersUnderCoBloc(injector()));
  injector.registerFactory<MobileVersionBloc>(() => MobileVersionBloc(injector()));
  injector.registerFactory<MobileTransactionUpdateBloc>(() => MobileTransactionUpdateBloc(injector()));
  injector.registerFactory<SyncDonationsBloc>(() => SyncDonationsBloc(injector(), injector(), injector()));

  ///REPOSITORY
  injector.registerSingleton<AuthRepository>(AuthRepositoryImpl(injector()));
  injector.registerSingleton<FundraisingRepository>(FundraisingRepositoryImpl(injector()));
  injector.registerSingleton<CurrentUserRepository>(CurrentUserRepositoryImpl(injector()));
  injector.registerSingleton<CurrentUserProfilePictureRepository>(CurrentUserProfilePictureRepositoryImpl(injector()));
  injector.registerSingleton<DonationsRepository>(DonationsRepositoryImpl(injector()));
  injector.registerSingleton<MobileTransactionRepository>(MobileTransactionRepositoryImpl(injector()));
  injector.registerSingleton<TenantSettingsRepository>(TenantSettingsRepoImpl(injector()));
  injector.registerSingleton<MembersUnderCORepository>(MembersUnderCORepositoryImpl(injector()));
  injector.registerSingleton<MobileVersionRepository>(MobileVersionImpl(injector()));

  ///USE CASE
  injector.registerSingleton<GetFundraisingUseCase>(GetFundraisingUseCase(injector()));
  injector.registerSingleton<GetAuthUseCase>(GetAuthUseCase(injector()));
  injector.registerSingleton<GetFundraisingAttachmentUseCase>(GetFundraisingAttachmentUseCase(injector()));
  injector.registerSingleton<GetTotalCountUseCase>(GetTotalCountUseCase(injector()));
  injector.registerSingleton<GetCurrentUserUseCase>(GetCurrentUserUseCase(injector()));
  injector.registerSingleton<GetCurrentUserProfilePictureUseCase>(GetCurrentUserProfilePictureUseCase(injector()));
  injector.registerSingleton<GetDonationsUseCase>(GetDonationsUseCase(injector()));
  injector.registerSingleton<GetCurrentUnRemittedUseCase>(GetCurrentUnRemittedUseCase(injector()));
  injector.registerSingleton<SendMobileTransactionUseCase>(SendMobileTransactionUseCase(injector()));
  injector.registerSingleton<UpdateCollectorAgentMasterRemittanceUseCase>(UpdateCollectorAgentMasterRemittanceUseCase(injector()));
  injector.registerSingleton<CreateMemberUnRemittedDonationForOfflineUseCase>(CreateMemberUnRemittedDonationForOfflineUseCase(injector()));
  injector.registerSingleton<TenantSettingsUseCase>(TenantSettingsUseCase(injector()));
  injector.registerSingleton<GetMemberUnderCOUseCase>(GetMemberUnderCOUseCase(injector()));
  injector.registerSingleton<GetRemittanceMasterDonationDetailsUseCase>(GetRemittanceMasterDonationDetailsUseCase(injector()));
  injector.registerSingleton<GetRemittanceMasterStatusUseCase>(GetRemittanceMasterStatusUseCase(injector()));
  injector.registerSingleton<GetCurrentUserRemittanceMasterUseCase>(GetCurrentUserRemittanceMasterUseCase(injector()));
  injector.registerSingleton<GetCurrentUserRemittanceMasterInProgressUseCase>(GetCurrentUserRemittanceMasterInProgressUseCase(injector()));
  injector.registerSingleton<GetCurrentUserRemittanceMasterCompletedUseCase>(GetCurrentUserRemittanceMasterCompletedUseCase(injector()));
  injector.registerSingleton<MobileVersionUseCase>(MobileVersionUseCase(injector()));
  injector.registerSingleton<UpdateMasterRemittanceAyannahUseCase>(UpdateMasterRemittanceAyannahUseCase(injector()));
  injector.registerSingleton<GetCurrentUserCollectedUnremittedDonationsUseCase>(GetCurrentUserCollectedUnremittedDonationsUseCase(injector()));
  injector.registerSingleton<CreateCollectedRemittanceMasterUseCase>(CreateCollectedRemittanceMasterUseCase(injector()));
  injector.registerSingleton<UpdateCollectorRemittanceAyannahUseCase>(UpdateCollectorRemittanceAyannahUseCase(injector()));
  injector.registerSingleton<UpdateCollectorRemittanceBrigadahanHeadQuarterUseCase>(UpdateCollectorRemittanceBrigadahanHeadQuarterUseCase(injector()));
}
