import 'package:kabrigadan_mobile/src/domain/entities/mobile_version/mobile_version_entity.dart';

class MobileVersionModel extends MobileVersionEntity {
  const MobileVersionModel({version, versionNotes,updateUrl})
      : super(version, versionNotes, updateUrl);

  factory MobileVersionModel.fromJson(Map<String, dynamic> json) {
    return MobileVersionModel(
        version: json['version'] as String?,
        versionNotes: json['versionNotes'] as String?,
        updateUrl: json['updateUrl'] as String?);
  }
}