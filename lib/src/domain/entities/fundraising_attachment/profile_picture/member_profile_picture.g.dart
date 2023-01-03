// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_profile_picture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberProfilePicture _$MemberProfilePictureFromJson(
        Map<String, dynamic> json) =>
    MemberProfilePicture(
      json['fileToken'] as String?,
      json['fileType'] as String?,
      json['fileUrl'] as String?,
      json['isPublic'] as bool?,
    );

Map<String, dynamic> _$MemberProfilePictureToJson(
        MemberProfilePicture instance) =>
    <String, dynamic>{
      'fileToken': instance.fileToken,
      'fileType': instance.fileType,
      'fileUrl': instance.fileUrl,
      'isPublic': instance.isPublic,
    };
