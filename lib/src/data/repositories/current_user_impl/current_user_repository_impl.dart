import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kabrigadan_mobile/src/core/params/current_user/current_user_params.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/data/datasources/remote/current_user/current_user_api_service.dart';
import 'package:kabrigadan_mobile/src/domain/entities/current_user/current_user_entity.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/current_user/current_user_repository.dart';

class CurrentUserRepositoryImpl implements CurrentUserRepository{
  final CurrentUserApiService _currentUserApiService;

  CurrentUserRepositoryImpl(this._currentUserApiService);

  @override
  Future<DataState<CurrentUserEntity>> getCurrentUser(CurrentUserParams? params) async {
    try{
      final httpResponse = await _currentUserApiService.getCurrentUser(params!.header, params.userId);

      if(httpResponse.response.statusCode == HttpStatus.ok){
        return DataSuccess(httpResponse.data.currentUserModel!);
      }

      return DataFailed(
        DioError(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          requestOptions: httpResponse.response.requestOptions,
          type: DioErrorType.response
        )
      );
    } on DioError catch (e){
      return DataFailed(e);
    }
  }
}