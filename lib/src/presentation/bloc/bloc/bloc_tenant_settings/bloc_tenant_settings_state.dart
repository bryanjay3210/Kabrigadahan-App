part of 'bloc_tenant_settings_bloc.dart';

abstract class TenantSettingsState extends Equatable {
  final DioError? error;
  const TenantSettingsState({this.error});

  @override
  List<Object> get props => [];
}

class GetTenantSettingsState extends TenantSettingsState {
  const GetTenantSettingsState();
}

class AuthError extends TenantSettingsState{
  const AuthError(DioError error) : super(error: error);
}
