// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentUserEntity _$CurrentUserEntityFromJson(Map<String, dynamic> json) =>
    CurrentUserEntity(
      json['name'] as String?,
      json['barangay'] as String?,
      json['purok'] as String?,
      json['mobileNumber'] as String?,
      json['imageFileToken'] as String?,
      json['memberId'] as String?,
      json['idNumber'] as String?,
      json['birthDate'] as String?,
      json['membershipLevel'] as int?,
      json['assignedOfficer'] as String?,
      json['cityQrCodeId'] as String?,
    );

Map<String, dynamic> _$CurrentUserEntityToJson(CurrentUserEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'barangay': instance.barangay,
      'purok': instance.purok,
      'mobileNumber': instance.mobileNumber,
      'imageFileToken': instance.imageFileToken,
      'memberId': instance.memberId,
      'idNumber': instance.idNumber,
      'birthDate': instance.birthDate,
      'membershipLevel': instance.membershipLevel,
      'assignedOfficer': instance.assignedOfficer,
      'cityQrCodeId': instance.cityQrCodeId,
    };
