import 'package:dio/dio.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/data/models/donations/super_donations_model.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/get_member_unremitted_donation_offline/super_get_member_unremitted_donation_offline.dart';
import 'package:retrofit/retrofit.dart';

part 'donations_api_service.g.dart';

@RestApi(baseUrl: kBaseUrl)
abstract class DonationsApiService {
  factory DonationsApiService(Dio dio, {String baseUrl}) = _DonationsApiService;

  @GET('/api/services/app/Donations/GetMobileDonationsCurrentUser')
  Future<HttpResponse<SuperDonationsModel>> getDonationsCurrentUser(
    @Header("Authorization") String? authorizationHeader
  );

  @GET('/api/services/app/MobileTransaction/GetCurrentUserUnremittedDonations')
  Future<HttpResponse<SuperGetMemberUnremittedDonationOfflineModel>> getUnRemittedDonationsCurrentUser(
      @Header("Authorization") String? authorizationHeader,
      @Query("CheckStatusOfExistingDonationIds") List<String>? checkStatusOfExistingDonationIds,
      @Query("SkipCount") int? skipCount
  );
}