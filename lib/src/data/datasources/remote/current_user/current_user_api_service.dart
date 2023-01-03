import 'package:dio/dio.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/data/models/current_user/members_under_CO/super_members_under_co.dart';
import 'package:kabrigadan_mobile/src/data/models/current_user/super_current_user_model.dart';
import 'package:kabrigadan_mobile/src/data/models/current_user/super_current_user_profile_picture_model.dart';
import 'package:retrofit/retrofit.dart';

part 'current_user_api_service.g.dart';

@RestApi(baseUrl: kBaseUrl)
abstract class CurrentUserApiService {
  factory CurrentUserApiService(Dio dio, {String baseUrl}) =
      _CurrentUserApiService;

  @GET('/api/services/app/Members/GetMemberWithUserId')
  Future<HttpResponse<SuperCurrentUserModel>> getCurrentUser(
      @Header("Authorization") String? authorizationHeader,
      @Query("id") int? userId);

  @GET('/api/services/app/Members/GetBinaryImage')
  Future<HttpResponse<SuperCurrentUserProfilePictureModel>> getCurrentUserProfilePicture(
      @Query("imageTokenId") String? imageTokenId
  );

  @GET('/api/services/app/Members/GetAllMemberByCO')
  Future<HttpResponse<SuperMembersUnderCOModel>> getAllMemberByCO(
      @Header("Authorization") String? authorizationHeader
  );
}
