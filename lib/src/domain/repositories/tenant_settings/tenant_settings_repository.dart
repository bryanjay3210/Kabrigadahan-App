import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/domain/entities/tenant_settings/tenant_settings_entity.dart';

abstract class TenantSettingsRepository{
  ///GET BRIGADAHAN FUNDS CODE
  Future<DataState<TenantSettingsEntity>> getTenantSettings();
}