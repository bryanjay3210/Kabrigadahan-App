import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/data/datasources/remote/tenant_settings/tenant_settings_api_service.dart';
import 'package:kabrigadan_mobile/src/domain/entities/tenant_settings/tenant_settings_entity.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/tenant_settings/tenant_settings_repository.dart';
import 'package:logger/logger.dart';

class TenantSettingsRepoImpl extends TenantSettingsRepository{
  final TenantSettingsApiService _tenantSettingsApiService;

  TenantSettingsRepoImpl(this._tenantSettingsApiService);

  @override
  Future<DataState<TenantSettingsEntity>> getTenantSettings() async {
    var logger = Logger();

    try{
      final httpResponse = await _tenantSettingsApiService.getTenantSettings();

      logger.i(httpResponse);

      if(httpResponse.response.statusCode == HttpStatus.ok){
        return DataSuccess(httpResponse.data.tenantSettingsModel!);
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