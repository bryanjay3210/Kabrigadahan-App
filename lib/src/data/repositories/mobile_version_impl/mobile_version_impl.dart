import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/get_preferences.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_version/mobile_setting_entity.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/mobile_version/mobile_version_repository.dart';
import 'package:logger/logger.dart';
import 'package:kabrigadan_mobile/src/data/datasources/remote/mobile_app_update/mobile_app_update_api_service.dart';

class MobileVersionImpl extends MobileVersionRepository{
  final MobileVersionApiService _mobileVersionApiService;

  MobileVersionImpl(this._mobileVersionApiService);

  @override
  Future<DataState<MobileSettingEntity>> getMobileVersion() async {
    var logger = Logger();

    try{
      String? accessToken = await GetPreferences().getStoredAccessToken();
      String? bearer = "Bearer $accessToken";
      final httpResponse = await _mobileVersionApiService.getMobileVersion(bearer);
      logger.i(httpResponse.data);

      if(httpResponse.response.statusCode == HttpStatus.ok){
        return DataSuccess(httpResponse.data.mobileAppUpdateModel!);
      }

      return DataFailed(
          DioError(
              error: httpResponse.response.statusMessage,
              response: httpResponse.response,
              requestOptions: httpResponse.response.requestOptions,
              type: DioErrorType.response
          )
      );
    } on DioError catch(e) {
      return DataFailed(e);
    }
  }
}