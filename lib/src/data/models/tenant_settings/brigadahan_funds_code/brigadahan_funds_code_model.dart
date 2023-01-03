import 'package:kabrigadan_mobile/src/domain/entities/tenant_settings/brigadahan_funds_code/brigadahan_funds_code_entity.dart';

class BrigadahanFundsCodeModel extends BrigadahanFundsCodeEntity {
  const BrigadahanFundsCodeModel({brigadahanFoundationFundsCode, brigadahanFoundationFundsRecipient, brigadahanFoundationTenantCodeAlias})
      : super(brigadahanFoundationFundsCode, brigadahanFoundationFundsRecipient, brigadahanFoundationTenantCodeAlias);

  factory BrigadahanFundsCodeModel.fromJson(Map<String, dynamic> json) {
    return BrigadahanFundsCodeModel(
        brigadahanFoundationFundsCode: json['brigadahanFoundationFundsCode'] as String?,
        brigadahanFoundationFundsRecipient: json['brigadahanFoundationFundsRecipient'] as String?,
        brigadahanFoundationTenantCodeAlias: json['brigadahanFoundationTenantCodeAlias'] as String?);
  }
}
