import 'package:dio/dio.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/data/models/auth/super_auth_model.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_service.g.dart';

@RestApi(baseUrl: kBaseUrl)
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @POST('/api/TokenAuth/AuthenticateMemberApp')
  Future<HttpResponse<SuperAuthModel>> tokenAuth(
    @Field("userNameOrEmailAddress") String? userNameOrEmailAddress,
    @Field("password") String? password,
    @Field("isOfficerOnMemberApp") bool? isOfficerOnMemberApp,
  );
}