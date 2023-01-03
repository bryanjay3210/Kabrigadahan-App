import 'package:dio/dio.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/data/models/fundraising/super_fundraising_model.dart';
import 'package:kabrigadan_mobile/src/data/models/fundraising_attachment/super_fundraising_attachment_model.dart';
import 'package:retrofit/retrofit.dart';

part 'fundraising_api_service.g.dart';

@RestApi(baseUrl: kBaseUrl)
abstract class FundraisingApiService {
  factory FundraisingApiService(Dio dio, {String baseUrl}) = _FundraisingApiService;

  @GET('/api/services/app/MobileApi/GetHomeFeeds')
  Future<HttpResponse<SuperFundraisingModel>> getFundraising(
    @Query("Skipcount") int? skipCount,
    @Query("Query") String? query
  );

  @GET('/api/services/app/MobileApi/GetHomeFeeds')
  Future<HttpResponse<SuperFundraisingModel>> getTotalCount();

  @GET('/api/services/app/MobileApi/GetMobileFundraisingsAndAttachments')
  Future<HttpResponse<SuperFundraisingAttachmentModel>> getFundraisingAttachment(
    @Query("fundraisingId") String? fundraisingId
  );
}