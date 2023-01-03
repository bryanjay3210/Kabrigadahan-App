import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kabrigadan_mobile/src/core/params/current_user/current_user_params.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/data/datasources/remote/current_user/current_user_api_service.dart';
import 'package:kabrigadan_mobile/src/domain/entities/current_user/current_user_entity.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/current_user/current_user_repository.dart';

class MembersUnderCORepositoryImpl implements MembersUnderCORepository {
  late final CurrentUserApiService _currentUserApiService;

  MembersUnderCORepositoryImpl(this._currentUserApiService);

  @override
  Future<DataState<List<CurrentUserEntity>>> getAllMemberByCO(CurrentUserParams? params) async {
    try{
      final httpResponse = await _currentUserApiService.getAllMemberByCO(params!.header);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data.membersUnderCOModelList!);
      }

      return DataFailed(DioError(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          requestOptions: httpResponse.response.requestOptions,
          type: DioErrorType.response));
    }
    on DioError catch (e){
      return DataFailed(e);
    }
  }

}