import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'specific_fundraising.g.dart';
@JsonSerializable()
class SpecificFundraising extends Equatable {
  final String? dateFiled;
  final bool? dependent;
  final String? verifierRemarks;
  final String? caseDescription;
  final String? diagnosis;
  final String? inNeedOf;
  final int? reason;
  final String? fundraiser;
  final String? approvedBy;
  final String? communityOfficer;
  final String? caseVerifiedBy;
  final double? amount;
  final String? caseCode;
  final int? status;
  final String? startDate;
  final String? endDate;
  final String? recipient;
  final String? id;

  const SpecificFundraising(this.dateFiled, this.dependent, this.verifierRemarks, this.caseDescription, this.diagnosis, this.inNeedOf, this.reason, this.fundraiser, this.approvedBy, this.communityOfficer,
      this.caseVerifiedBy, this.amount, this.caseCode, this.status, this.startDate, this.endDate, this.recipient, this.id);

  @override
  List<Object?> get props => [dateFiled, dependent, verifierRemarks, caseDescription, diagnosis, inNeedOf, reason, fundraiser, approvedBy, communityOfficer, caseVerifiedBy, amount, caseCode, status, startDate, endDate, recipient, id];

  @override
  bool? get stringify => true;

  factory SpecificFundraising.fromJson(Map<String, dynamic> json) => _$SpecificFundraisingFromJson(json);
  Map<String, dynamic> toJson() => _$SpecificFundraisingToJson(this);
}