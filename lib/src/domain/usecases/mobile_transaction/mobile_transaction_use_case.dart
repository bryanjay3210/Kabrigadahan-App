import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/create_collected_remittance_master_params/create_collected_remittance_master_params.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/create_member_unremitted_offline/create_member_unremitted_offline_params.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/get_member_remittance_status/get_member_remittance_status.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/get_remittance_master_donation_details/get_remittancer_master_donation_details_master.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/mobile_transaction_params.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/update_collector_agent_master/update_collector_agent_master.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/update_collector_remittance_ayannah/update_collector_remittance_ayannah.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/update_collector_remittance_brigadahan_headquarters/update_collector_remittance_brigadahan_headquarters.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/update_master_remittance_ayannah/update_master_remittance_ayannah_params.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/core/usecases/usecase.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_current_user_collected_unremitted_donations/get_current_user_collected_unremitted_donations_model.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_current_user_remittance_master/get_current_user_remittance_master.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_remittance_master_status/remittancer_master_status.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/create_unpaid_collected_remittance_master/create_unpaid_collected_remittance_master.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/member_unremitted_donation_model/member_unremitted_donation_model.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/member_unremitted_donation_results.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/unpaid_remittance_master.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/mobile_transaction/mobile_transaction_repository.dart';

class SendMobileTransactionUseCase implements UseCase<DataState<UnpaidRemittanceMasterEntity>, MobileTransactionParams?>{
  final MobileTransactionRepository mobileTransactionRepository;

  SendMobileTransactionUseCase(this.mobileTransactionRepository);

  @override
  Future<DataState<UnpaidRemittanceMasterEntity>> call({MobileTransactionParams? params}) {
    return mobileTransactionRepository.createUnpaidRemittance(params!.accessToken, params.agentMemberId, params.memberUnRemittedDonations);
  }
}

class UpdateCollectorAgentMasterRemittanceUseCase implements UseCase<DataState<void>, UpdateCollectorAgentMasterParams?>{
  final MobileTransactionRepository mobileTransactionRepository;

  UpdateCollectorAgentMasterRemittanceUseCase(this.mobileTransactionRepository);

  @override
  Future<DataState<void>> call({UpdateCollectorAgentMasterParams? params}) {
    return mobileTransactionRepository.updateCollectorAgentMasterRemittance(params!.masterRemittanceId, params.collectorAgentId);
  }
}

class CreateMemberUnRemittedDonationForOfflineUseCase implements UseCase<DataState<List<MemberUnremittedDonationResultsEntity>>, CreateMemberUnremittedOfflineParams?>{
  final MobileTransactionRepository mobileTransactionRepository;

  CreateMemberUnRemittedDonationForOfflineUseCase(this.mobileTransactionRepository);

  @override
  Future<DataState<List<MemberUnremittedDonationResultsEntity>>> call({CreateMemberUnremittedOfflineParams? params}) {
    return mobileTransactionRepository.createMemberUnRemittedDonationForOffline(params!.createOrEditMemberUnRemittedDonation);
  }
}

class GetRemittanceMasterDonationDetailsUseCase implements UseCase<DataState<List<MemberUnremittedDonationResultsEntity>>, GetRemittancerMasterDonationDetailsParams?>{
  final MobileTransactionRepository mobileTransactionRepository;

  GetRemittanceMasterDonationDetailsUseCase(this.mobileTransactionRepository);

  @override
  Future<DataState<List<MemberUnremittedDonationResultsEntity>>> call({GetRemittancerMasterDonationDetailsParams? params}) {
    return mobileTransactionRepository.getRemittanceMasterDonationDetails(params!.authorizationHeader, params.memberRemittanceMasterId);
  }
}

class GetRemittanceMasterStatusUseCase implements UseCase<DataState<List<RemittanceMasterStatus>>, GetMemberRemittanceStatusParams?>{
  final MobileTransactionRepository mobileTransactionRepository;

  GetRemittanceMasterStatusUseCase(this.mobileTransactionRepository);

  @override
  Future<DataState<List<RemittanceMasterStatus>>> call({GetMemberRemittanceStatusParams? params}) {
    return mobileTransactionRepository.getRemittanceMasterStatus(params!.authorizationHeader, params.remittanceMasterId);
  }
}

class GetCurrentUserRemittanceMasterUseCase implements UseCase<DataState<GetCurrentUserRemittanceMaster>, String?>{
  final MobileTransactionRepository mobileTransactionRepository;

  GetCurrentUserRemittanceMasterUseCase(this.mobileTransactionRepository);

  @override
  Future<DataState<GetCurrentUserRemittanceMaster>> call({String? params}) {
    return mobileTransactionRepository.getCurrentUserRemittanceMaster(params);
  }
}

class GetCurrentUserRemittanceMasterInProgressUseCase implements UseCase<DataState<GetCurrentUserRemittanceMaster>, String?>{
  final MobileTransactionRepository mobileTransactionRepository;

  GetCurrentUserRemittanceMasterInProgressUseCase(this.mobileTransactionRepository);

  @override
  Future<DataState<GetCurrentUserRemittanceMaster>> call({String? params}) {
    return mobileTransactionRepository.getCurrentUserRemittanceMasterInProgress(params);
  }
}

class GetCurrentUserRemittanceMasterCompletedUseCase implements UseCase<DataState<GetCurrentUserRemittanceMaster>, String?>{
  final MobileTransactionRepository mobileTransactionRepository;

  GetCurrentUserRemittanceMasterCompletedUseCase(this.mobileTransactionRepository);

  @override
  Future<DataState<GetCurrentUserRemittanceMaster>> call({String? params}) {
    return mobileTransactionRepository.getCurrentUserRemittanceMasterCompleted(params);
  }
}

class UpdateMasterRemittanceAyannahUseCase implements UseCase<DataState<void>, UpdateMasterRemittanceAyannahParams?>{
  final MobileTransactionRepository mobileTransactionRepository;

  UpdateMasterRemittanceAyannahUseCase(this.mobileTransactionRepository);

  @override
  Future<DataState<void>> call({UpdateMasterRemittanceAyannahParams? params}) {
    return mobileTransactionRepository.updateMasterRemittancePaidInAyannah(params!.masterRemittanceId, params.transactionId, params.receiptFileAttachment);
  }
}

class GetCurrentUserCollectedUnremittedDonationsUseCase implements UseCase<DataState<GetCurrentUserCollectedUnremittedDonationsModel>, String?>{
  final MobileTransactionRepository mobileTransactionRepository;

  GetCurrentUserCollectedUnremittedDonationsUseCase(this.mobileTransactionRepository);

  @override
  Future<DataState<GetCurrentUserCollectedUnremittedDonationsModel>> call({String? params}) {
    return mobileTransactionRepository.getCurrentUserCollectedUnremittedDonations(params);
  }
}
class CreateCollectedRemittanceMasterUseCase implements UseCase<DataState<CreateUnpaidCollectedRemittanceMasterModel>, CreateCollectedRemittanceMasterParams?>{
  final MobileTransactionRepository mobileTransactionRepository;

  CreateCollectedRemittanceMasterUseCase(this.mobileTransactionRepository);

  @override
  Future<DataState<CreateUnpaidCollectedRemittanceMasterModel>> call({CreateCollectedRemittanceMasterParams? params}) {
    return mobileTransactionRepository.createUnpaidCollectedRemittanceMaster(params!);
  }
}

class UpdateCollectorRemittanceAyannahUseCase implements UseCase<DataState<void>, UpdateCollectorRemittanceAyannahParams?>{
  final MobileTransactionRepository mobileTransactionRepository;

  UpdateCollectorRemittanceAyannahUseCase(this.mobileTransactionRepository);

  @override
  Future<DataState<void>> call({UpdateCollectorRemittanceAyannahParams? params}) {
    return mobileTransactionRepository.updateCollectorRemittanceAyannah(params!);
  }
}

class UpdateCollectorRemittanceBrigadahanHeadQuarterUseCase implements UseCase<DataState<void>, UpdateCollectorRemittanceBrigadahanHeadquartersParams?>{
  final MobileTransactionRepository mobileTransactionRepository;

  UpdateCollectorRemittanceBrigadahanHeadQuarterUseCase(this.mobileTransactionRepository);

  @override
  Future<DataState<void>> call({UpdateCollectorRemittanceBrigadahanHeadquartersParams? params}) {
    return mobileTransactionRepository.updateCollectorRemittanceBrigadahanHeadQuarter(params!);
  }
}

