import 'package:kabrigadan_mobile/src/core/params/current_user/current_user_profile_picture_params.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/core/usecases/usecase.dart';
import 'package:kabrigadan_mobile/src/domain/entities/current_user/current_user_profile_picture_entity.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/current_user/current_user_profile_picture_repository.dart';

class GetCurrentUserProfilePictureUseCase implements UseCase<DataState<CurrentUserProfilePictureEntity>, CurrentUserProfilePictureParams?> {
  final CurrentUserProfilePictureRepository _currentUserProfilePictureRepository;

  GetCurrentUserProfilePictureUseCase(this._currentUserProfilePictureRepository);

  @override
  Future<DataState<CurrentUserProfilePictureEntity>> call({CurrentUserProfilePictureParams? params}) {
    return _currentUserProfilePictureRepository.getCurrentUserProfilePicture(params);
  }
}
