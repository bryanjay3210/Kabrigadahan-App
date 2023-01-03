// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fundraising_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FundraisingItem _$FundraisingItemFromJson(Map<String, dynamic> json) =>
    FundraisingItem(
      json['fundraising'] == null
          ? null
          : SpecificFundraising.fromJson(
              json['fundraising'] as Map<String, dynamic>),
      json['fundRaiser'] as String?,
      json['approvedBy'] as String?,
      json['communityOfficer'] as String?,
      json['verifiedBy'] as String?,
      json['fundraisingBatchName'] as String?,
    );

Map<String, dynamic> _$FundraisingItemToJson(FundraisingItem instance) =>
    <String, dynamic>{
      'fundraising': instance.fundraising,
      'fundRaiser': instance.fundRaiser,
      'approvedBy': instance.approvedBy,
      'communityOfficer': instance.communityOfficer,
      'verifiedBy': instance.verifiedBy,
      'fundraisingBatchName': instance.fundraisingBatchName,
    };
