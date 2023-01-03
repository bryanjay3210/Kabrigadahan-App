import 'package:dio/dio.dart';
import 'package:kabrigadan_mobile/src/core/params/auth/auth_params.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/data/datasources/remote/auth/auth_api_service.dart';
import 'package:kabrigadan_mobile/src/domain/entities/auth/auth_entity.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/auth/auth_repository.dart';

import 'dart:io';

import 'package:logger/logger.dart';

class AuthRepositoryImpl implements AuthRepository{
 final AuthApiService _authApiService;

  AuthRepositoryImpl(this._authApiService);


  @override
  Future<DataState<AuthEntity>> tokenAuth(AuthParams? params) async {
    var logger = Logger();
    logger.i(params!.userNameOrEmailAddress);
    logger.i(params.password);

    try{
      final httpResponse = await _authApiService.tokenAuth(params.userNameOrEmailAddress, params.password, params.isOfficerOnMemberApp);

      logger.i(httpResponse.data.result!.authResult);

      if(httpResponse.response.statusCode == HttpStatus.ok){
        return DataSuccess(httpResponse.data.result!);
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