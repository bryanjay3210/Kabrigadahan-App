import 'package:dio/dio.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_current_user_collected_unremitted_donations/super_get_current_user_collected_unremitted_donations_model.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_current_user_remittance_master/super_get_current_user_remittance_master.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_remittance_master_donation_model/super_get_remittance_master_donation_model.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_remittance_master_status/super_remittance_master_status.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/create_member_unremitted_donation_offline/super_create_member_unremitted_donation_offline_model.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/create_unpaid_collected_remittance_master/super_create_unpaid_collected_remittance_master.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/super_unpaid_remittance_master.dart';
import 'package:retrofit/retrofit.dart';

part 'mobile_transaction_api_service.g.dart';

@RestApi(baseUrl: kBaseUrl)
abstract class MobileTransactionApiService {
  factory MobileTransactionApiService(Dio dio, {String baseUrl}) = _MobileTransactionApiService;

  @POST('/api/services/app/MobileTransaction/CreateUnpaidRemittanceMaster')
  Future<HttpResponse<SuperUnpaidRemittanceMasterModel>> createUnpaidRemittance(
    @Header("Authorization") String? authorizationHeader,
    @Field("agentMemberId") String? agentMemberId,
    @Field("memberUnRemittedDonations") List<Map<String, dynamic>>? memberUnRemittedDonations,
  );

  @PUT('/api/services/app/MobileTransaction/UpdateCollectorAgentInMasterRemittance')
  Future<HttpResponse<void>> updateCollectorAgentMasterRemittance(
      @Header("Authorization") String? authorizationHeader,
      @Field("masterRemittanceId") String? masterRemittanceId,
      @Field("collectorAgentId") String? collectorAgentId
  );

  @PUT('/api/services/app/MobileTransaction/UpdateMasterRemittancePaidInAyannah')
  Future<HttpResponse<void>> updateMasterRemittancePaidInAyannah(
      @Header("Authorization") String? authorizationHeader,
      @Field("masterRemittanceId") String? masterRemittanceId,
      @Field("transactionId") String? transactionId,
      @Field("receiptFileAttachment") String? receiptFileAttachment,
  );

  @POST('/api/services/app/MobileTransaction/CreateMemberUnRemittedDonationForSynching')
  Future<HttpResponse<SuperCreateMemberUnremittedDonationOfflineModel>> createMemberUnRemittedDonationForOffline(
      @Header("Authorization") String? authorizationHeader,
      @Field("createOrEditMemberUnRemittedDonation") List<Map<String, dynamic>>? memberUnRemittedDonations,
  );

  @GET('/api/services/app/MobileTransaction/GetRemittanceMasterDonationDetails')
  Future<HttpResponse<SuperGetRemittanceMasterDonationModel>> getRemittanceMasterDonationDetails(
      @Header("Authorization") String? authorizationHeader,
      @Query("id") String? memberRemittanceMasterId
  );

  @GET('/api/services/app/MobileTransaction/GetRemittanceMastersStatus')
  Future<HttpResponse<SuperRemittanceMasterStatus>> getRemittanceMastersStatus(
      @Header("Authorization") String? authorizationHeader,
      @Query("id") List<String>? remittanceMasterId
  );

  @GET('/api/services/app/MobileTransaction/GetCurrentUserRemittanceMaster')
  Future<HttpResponse<SuperGetCurrentUserRemittanceMaster>> getCurrentUserRemittanceMaster(
      @Header("Authorization") String? authorizationHeader
  );

  @GET('/api/services/app/MobileTransaction/GetCurrentUserRemittanceMasterInProgress')
  Future<HttpResponse<SuperGetCurrentUserRemittanceMaster>> getCurrentUserRemittanceMasterInProgress(
    @Header("Authorization") String? authorizationHeader
  );

  @GET('/api/services/app/MobileTransaction/GetCurrentUserRemittanceMasterCompleted')
  Future<HttpResponse<SuperGetCurrentUserRemittanceMaster>> getCurrentUserRemittanceMasterCompleted(
    @Header("Authorization") String? authorizationHeader
  );

  @GET('/api/services/app/MobileTransaction/GetCurrentUserCollectedUnremittedDonations')
  Future<HttpResponse<SuperGetCurrentUserCollectedUnremittedDonationsModel>> getCurrentUserCollectedUnremittedDonations(
    @Header("Authorization") String? authorizationHeader,
    @Query("MaxResultCount") int? maxResultCount
  );

  //TODO: CREATE MODEL FOR EXPECTED RESPONSE
  @POST('/api/services/app/MobileTransaction/CreateUnpaidCollectedRemittanceMaster')
  Future<HttpResponse<SuperCreateUnpaidCollectedRemittanceMasterModel>> createUnpaidCollectedRemittanceMaster(
      @Header("Authorization") String? authorizationHeader,
      @Field("collectorMemberId") String? collectorMemberId,
  );

  @PUT('/api/services/app/MobileTransaction/UpdateCollectorRemittanceAyannah')
  Future<HttpResponse<void>> updateCollectorRemittanceAyannah(
      @Header("Authorization") String? authorizationHeader,
      @Field("collectedRemittanceMasterId") String? collectedRemittanceMasterId
      );

  @PUT('/api/services/app/MobileTransaction/UpdateCollectorRemittanceBrigadahanHeadQuarter')
  Future<HttpResponse<void>> updateCollectorRemittanceBrigadahanHeadQuarter(
      @Header("Authorization") String? authorizationHeader,
      @Field("collectedRemittanceMasterId") String? collectedRemittanceMasterId
      );
}