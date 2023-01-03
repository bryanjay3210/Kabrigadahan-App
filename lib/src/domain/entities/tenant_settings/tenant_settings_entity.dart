import 'package:equatable/equatable.dart';
import 'package:kabrigadan_mobile/src/domain/entities/tenant_settings/brigadahan_funds_code/brigadahan_funds_code_entity.dart';

class TenantSettingsEntity extends Equatable{
  final BrigadahanFundsCodeEntity? brigadahanFundsCodeEntity;

  const TenantSettingsEntity(this.brigadahanFundsCodeEntity);

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}