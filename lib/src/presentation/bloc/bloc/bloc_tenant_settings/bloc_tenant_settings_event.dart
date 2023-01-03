part of 'bloc_tenant_settings_bloc.dart';

abstract class TenantSettingsEvent extends Equatable {
  const TenantSettingsEvent();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class GetTenantSettingsEvent extends TenantSettingsEvent{
  const GetTenantSettingsEvent();
}
