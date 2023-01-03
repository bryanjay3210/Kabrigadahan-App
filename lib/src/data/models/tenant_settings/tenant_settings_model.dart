import 'package:kabrigadan_mobile/src/data/models/tenant_settings/brigadahan_funds_code/brigadahan_funds_code_model.dart';
import 'package:kabrigadan_mobile/src/domain/entities/tenant_settings/tenant_settings_entity.dart';

class TenantSettingsModel extends TenantSettingsEntity{
  const TenantSettingsModel({brigadahanFundsCodeEntity}) : super(brigadahanFundsCodeEntity);

  factory TenantSettingsModel.fromJson(Map<String, dynamic> json){
    return TenantSettingsModel(
      brigadahanFundsCodeEntity: BrigadahanFundsCodeModel.fromJson(json['brgadahanFoundationFundsSettings'])
    );
  }
}