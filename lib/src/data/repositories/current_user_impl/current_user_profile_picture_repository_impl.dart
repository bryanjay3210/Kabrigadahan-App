import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kabrigadan_mobile/src/core/params/current_user/current_user_profile_picture_params.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/data/datasources/remote/current_user/current_user_api_service.dart';
import 'package:kabrigadan_mobile/src/domain/entities/current_user/current_user_profile_picture_entity.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/current_user/current_user_profile_picture_repository.dart';

class CurrentUserProfilePictureRepositoryImpl implements CurrentUserProfilePictureRepository {
  final CurrentUserApiService _currentUserApiService;

  CurrentUserProfilePictureRepositoryImpl(this._currentUserApiService);

  @override
  Future<DataState<CurrentUserProfilePictureEntity>>getCurrentUserProfilePicture(CurrentUserProfilePictureParams? params) async {
    try {
      final httpResponse = await _currentUserApiService.getCurrentUserProfilePicture(params!.imageTokenId);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data.currentUserProfilePictureModel!);
      }

      return DataFailed(DioError(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          requestOptions: httpResponse.response.requestOptions,
          type: DioErrorType.response));
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }
}
