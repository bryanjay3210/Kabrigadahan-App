import 'package:equatable/equatable.dart';

class BrigadahanFundsCodeEntity extends Equatable{
  final String? brigadahanFoundationFundsCode;
  final String? brigadahanFoundationFundsRecipient;
  final String? brigadahanFoundationTenantCodeAlias;

  const BrigadahanFundsCodeEntity(this.brigadahanFoundationFundsCode, this.brigadahanFoundationFundsRecipient, this.brigadahanFoundationTenantCodeAlias);

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}