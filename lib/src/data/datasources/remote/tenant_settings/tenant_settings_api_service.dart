import 'package:dio/dio.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/data/models/tenant_settings/super_tenant_settings_model.dart';
import 'package:retrofit/retrofit.dart';

part 'tenant_settings_api_service.g.dart';

@RestApi(baseUrl: kBaseUrl)
abstract class TenantSettingsApiService {
  factory TenantSettingsApiService(Dio dio, {String baseUrl}) = _TenantSettingsApiService;

  @GET('/api/services/app/Account/GetAllSettings')
  Future<HttpResponse<SuperTenantSettingsModel>> getTenantSettings();
}