// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fundraising_attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FundraisingAttachment _$FundraisingAttachmentFromJson(
        Map<String, dynamic> json) =>
    FundraisingAttachment(
      (json['photos'] as List<dynamic>?)
          ?.map((e) =>
              FundraisingAttachmentPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['fundraiser'] == null
          ? null
          : Fundraiser.fromJson(json['fundraiser'] as Map<String, dynamic>),
      json['memberProfilePicture'] == null
          ? null
          : MemberProfilePicture.fromJson(
              json['memberProfilePicture'] as Map<String, dynamic>),
      json['fundraisingAttachmentDetails'] == null
          ? null
          : FundraisingAttachmentDetails.fromJson(
              json['fundraisingAttachmentDetails'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FundraisingAttachmentToJson(
        FundraisingAttachment instance) =>
    <String, dynamic>{
      'photos': instance.photos,
      'fundraiser': instance.fundraiser,
      'memberProfilePicture': instance.memberProfilePicture,
      'fundraisingAttachmentDetails': instance.fundraisingAttachmentDetails,
    };
