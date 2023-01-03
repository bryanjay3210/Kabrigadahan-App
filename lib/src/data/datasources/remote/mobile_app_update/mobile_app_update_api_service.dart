import 'package:dio/dio.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_app_update/super_mobile_app_update_model.dart';
import 'package:retrofit/retrofit.dart';

part 'mobile_app_update_api_service.g.dart';

@RestApi(baseUrl: kBaseUrl)
abstract class MobileVersionApiService {
  factory MobileVersionApiService(Dio dio, {String baseUrl}) = _MobileVersionApiService;

  @GET('/api/services/app/Account/GetAllSettings')
  Future<HttpResponse<SuperMobileAppUpdateModel>> getMobileVersion(
      @Header("Authorization") String? authorizationHeader
      );
}