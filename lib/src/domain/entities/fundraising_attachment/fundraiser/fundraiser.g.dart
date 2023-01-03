// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fundraiser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fundraiser _$FundraiserFromJson(Map<String, dynamic> json) => Fundraiser(
      json['member'] == null
          ? null
          : FundraisingAttachmentMember.fromJson(
              json['member'] as Map<String, dynamic>),
      json['barangayName'] as String?,
      json['purokName'] as String?,
      json['religionName'] as String?,
      json['userName'] as String?,
    );

Map<String, dynamic> _$FundraiserToJson(Fundraiser instance) =>
    <String, dynamic>{
      'member': instance.member,
      'barangayName': instance.barangayName,
      'purokName': instance.purokName,
      'religionName': instance.religionName,
      'userName': instance.userName,
    };
