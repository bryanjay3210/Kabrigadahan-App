import 'package:kabrigadan_mobile/src/core/params/current_user/current_user_profile_picture_params.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/domain/entities/current_user/current_user_profile_picture_entity.dart';

abstract class CurrentUserProfilePictureRepository {
  Future<DataState<CurrentUserProfilePictureEntity>>
      getCurrentUserProfilePicture(CurrentUserProfilePictureParams? params);
}
