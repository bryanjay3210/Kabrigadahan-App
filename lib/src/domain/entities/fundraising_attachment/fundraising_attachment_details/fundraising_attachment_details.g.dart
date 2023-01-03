// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fundraising_attachment_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FundraisingAttachmentDetails _$FundraisingAttachmentDetailsFromJson(
        Map<String, dynamic> json) =>
    FundraisingAttachmentDetails(
      json['fundraising'] == null
          ? null
          : SpecificFundraising.fromJson(
              json['fundraising'] as Map<String, dynamic>),
      json['fundRaiser'] as String?,
      json['approvedBy'] as String?,
      json['communityOfficer'] as String?,
      json['verifiedBy'] as String?,
    );

Map<String, dynamic> _$FundraisingAttachmentDetailsToJson(
        FundraisingAttachmentDetails instance) =>
    <String, dynamic>{
      'fundraising': instance.fundraising,
      'fundRaiser': instance.fundRaiser,
      'approvedBy': instance.approvedBy,
      'communityOfficer': instance.communityOfficer,
      'verifiedBy': instance.verifiedBy,
    };
