import 'package:kabrigadan_mobile/src/data/models/current_user/current_user_profile_picture_model.dart';

class SuperCurrentUserProfilePictureModel {
  final CurrentUserProfilePictureModel? currentUserProfilePictureModel;

  SuperCurrentUserProfilePictureModel({this.currentUserProfilePictureModel});

  factory SuperCurrentUserProfilePictureModel.fromJson(
      Map<String, dynamic> json) {
    return SuperCurrentUserProfilePictureModel(
        currentUserProfilePictureModel:
            CurrentUserProfilePictureModel.fromJson(json['result']));
  }
}
