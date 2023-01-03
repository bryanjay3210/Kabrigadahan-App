import 'package:kabrigadan_mobile/src/domain/entities/current_user/current_user_profile_picture_entity.dart';

class CurrentUserProfilePictureModel extends CurrentUserProfilePictureEntity {
  const CurrentUserProfilePictureModel({fileToken, fileType})
      : super(fileToken, fileType);

  factory CurrentUserProfilePictureModel.fromJson(Map<String, dynamic> json) {
    return CurrentUserProfilePictureModel(
      fileToken: json['fileToken'] as String?,
      fileType: json['fileType'] as String?,
    );
  }
}
