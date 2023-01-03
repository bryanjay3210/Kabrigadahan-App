// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FundraisingAttachmentMember _$FundraisingAttachmentMemberFromJson(
        Map<String, dynamic> json) =>
    FundraisingAttachmentMember(
      json['firstName'] as String?,
      json['middleName'] as String?,
      json['lastName'] as String?,
      json['mobileNumber'] as String?,
      json['address'] as String?,
      json['isEmployed'] as bool?,
      json['emergencyName'] as String?,
      json['emergencyMobileNumber'] as String?,
      json['idNumber'] as String?,
      json['gender'] as int?,
    );

Map<String, dynamic> _$FundraisingAttachmentMemberToJson(
        FundraisingAttachmentMember instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'mobileNumber': instance.mobileNumber,
      'address': instance.address,
      'isEmployed': instance.isEmployed,
      'emergencyName': instance.emergencyName,
      'emergencyMobileNumber': instance.emergencyMobileNumber,
      'idNumber': instance.idNumber,
      'gender': instance.gender,
    };
