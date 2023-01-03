import 'dart:io';

import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/create_collected_remittance_master_params/create_collected_remittance_master_params.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/update_collector_remittance_ayannah/update_collector_remittance_ayannah.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/update_collector_remittance_brigadahan_headquarters/update_collector_remittance_brigadahan_headquarters.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_current_user_collected_unremitted_donations/get_current_user_collected_unremitted_donations_model.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_current_user_remittance_master/get_current_user_remittance_master.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_remittance_master_status/remittancer_master_status.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/create_unpaid_collected_remittance_master/create_unpaid_collected_remittance_master.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/create_unpaid_collected_remittance_master/super_create_unpaid_collected_remittance_master.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/member_unremitted_donation_results.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/unpaid_remittance_master.dart';

abstract class MobileTransactionRepository{
  ///API FOR MOBILE TRANSACTION
  Future<DataState<UnpaidRemittanceMasterEntity>> createUnpaidRemittance(String? accessToken, String? agentMemberId, List<String>? memberUnRemittedDonations);

  ///UPDATE REMITTANCE MASTER
  Future<DataState<void>> updateCollectorAgentMasterRemittance(String? masterRemittanceId, String? collectorAgentId);

  ///UPDATE REMITTANCE MASTER PAID IN AYANNAH
  Future<DataState<void>> updateMasterRemittancePaidInAyannah(String? masterRemittanceId, String? transactionId, String? receiptFileAttachment);

  ///AUTO - SYNCING
  Future<DataState<List<MemberUnremittedDonationResultsEntity>>> createMemberUnRemittedDonationForOffline(List<Map<String, dynamic>>? createOrEditMemberUnRemittedDonation);

  ///GET REMITTANCE MASTER DONATION DETAILS
  Future<DataState<List<MemberUnremittedDonationResultsEntity>>> getRemittanceMasterDonationDetails(String? accessToken, String? memberRemittanceMasterId);

  ///GET REMITTANCE MEMBER STATUS
  Future<DataState<List<RemittanceMasterStatus>>> getRemittanceMasterStatus(String? accessToken, List<String>? memberRemittanceMasterId);

  ///GET CURRENT USER REMITTANCE MASTERS
  Future<DataState<GetCurrentUserRemittanceMaster>> getCurrentUserRemittanceMaster(String? accessToken);

  ///GET CURRENT USER REMITTANCE MASTERS
  Future<DataState<GetCurrentUserRemittanceMaster>> getCurrentUserRemittanceMasterInProgress(String? accessToken);

  ///GET CURRENT USER REMITTANCE MASTERS
  Future<DataState<GetCurrentUserRemittanceMaster>> getCurrentUserRemittanceMasterCompleted(String? accessToken);

  ///GET CURRENT USER REMITTANCE MASTERS
  Future<DataState<GetCurrentUserCollectedUnremittedDonationsModel>> getCurrentUserCollectedUnremittedDonations(String? accessToken);

  Future<DataState<CreateUnpaidCollectedRemittanceMasterModel>> createUnpaidCollectedRemittanceMaster(CreateCollectedRemittanceMasterParams createCollectedRemittanceMasterParams);

  Future<DataState<void>> updateCollectorRemittanceAyannah(UpdateCollectorRemittanceAyannahParams updateCollectorRemittanceAyannahParams);

  Future<DataState<void>> updateCollectorRemittanceBrigadahanHeadQuarter(UpdateCollectorRemittanceBrigadahanHeadquartersParams updateCollectorRemittanceBrigadahanHeadquartersParams);
}