import 'package:kabrigadan_mobile/src/data/models/tenant_settings/tenant_settings_model.dart';

class SuperTenantSettingsModel {
  final TenantSettingsModel? tenantSettingsModel;

  SuperTenantSettingsModel({this.tenantSettingsModel});

  factory SuperTenantSettingsModel.fromJson(Map<String, dynamic> json){
    return SuperTenantSettingsModel(
      tenantSettingsModel: TenantSettingsModel.fromJson(json['result'])
    );
  }
}