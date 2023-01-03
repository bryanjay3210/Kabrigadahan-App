// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specific_fundraising.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecificFundraising _$SpecificFundraisingFromJson(Map<String, dynamic> json) =>
    SpecificFundraising(
      json['dateFiled'] as String?,
      json['dependent'] as bool?,
      json['verifierRemarks'] as String?,
      json['caseDescription'] as String?,
      json['diagnosis'] as String?,
      json['inNeedOf'] as String?,
      json['reason'] as int?,
      json['fundraiser'] as String?,
      json['approvedBy'] as String?,
      json['communityOfficer'] as String?,
      json['caseVerifiedBy'] as String?,
      (json['amount'] as num?)?.toDouble(),
      json['caseCode'] as String?,
      json['status'] as int?,
      json['startDate'] as String?,
      json['endDate'] as String?,
      json['recipient'] as String?,
      json['id'] as String?,
    );

Map<String, dynamic> _$SpecificFundraisingToJson(
        SpecificFundraising instance) =>
    <String, dynamic>{
      'dateFiled': instance.dateFiled,
      'dependent': instance.dependent,
      'verifierRemarks': instance.verifierRemarks,
      'caseDescription': instance.caseDescription,
      'diagnosis': instance.diagnosis,
      'inNeedOf': instance.inNeedOf,
      'reason': instance.reason,
      'fundraiser': instance.fundraiser,
      'approvedBy': instance.approvedBy,
      'communityOfficer': instance.communityOfficer,
      'caseVerifiedBy': instance.caseVerifiedBy,
      'amount': instance.amount,
      'caseCode': instance.caseCode,
      'status': instance.status,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'recipient': instance.recipient,
      'id': instance.id,
    };
