part of 'bloc_mobile_transaction_bloc.dart';

abstract class MobileTransactionEvent extends Equatable {
  const MobileTransactionEvent();

  @override
  List<Object?> get props => [];
}

class SendingMobileTransactionEvent extends MobileTransactionEvent{
  const SendingMobileTransactionEvent();
}

class SendMobileTransactionEvent extends MobileTransactionEvent{
  final MobileTransactionParams mobileTransactionParams;
  final CreateCollectedRemittanceMasterParams createCollectedRemittanceMasterParams;
  final BuildContext context;
  final List<RemittedDonation> toBeRemittedList;
  final VoidCallback refresh;
  const SendMobileTransactionEvent(this.createCollectedRemittanceMasterParams, {required this.mobileTransactionParams, required this.context, required this.toBeRemittedList, required this.refresh,});
}

class UpdateCollectorAgentMasterEvent extends MobileTransactionEvent{
  final UpdateCollectorAgentMasterParams updateCollectorAgentMasterParams;
  const UpdateCollectorAgentMasterEvent({required this.updateCollectorAgentMasterParams});
}

class UpdateMasterRemittanceAyannahEvent extends MobileTransactionEvent{
  final UpdateMasterRemittanceAyannahParams updateMasterRemittanceAyannahParams;
  const UpdateMasterRemittanceAyannahEvent({required this.updateMasterRemittanceAyannahParams});
}

class GetRemittanceMasterDetailsEvent extends MobileTransactionEvent{
  final GetRemittancerMasterDonationDetailsParams getRemittancerMasterDonationDetailsParams;
  final String memberRemittanceMasterId;
  final BuildContext context;
  final VoidCallback refresh;
  final bool? isCancelTransaction;
  const GetRemittanceMasterDetailsEvent(this.getRemittancerMasterDonationDetailsParams, this.memberRemittanceMasterId, this.context, this.refresh, this.isCancelTransaction);
}

class ShowRemittanceMasterDetailsEvent extends MobileTransactionEvent{
  final GetRemittancerMasterDonationDetailsParams getRemittancerMasterDonationDetailsParams;
  final String memberRemittanceMasterId;
  final BuildContext context;
  const ShowRemittanceMasterDetailsEvent(this.getRemittancerMasterDonationDetailsParams, this.memberRemittanceMasterId, this.context);
}

class GetCurrentUserRemittanceMasterEvent extends MobileTransactionEvent{
  const GetCurrentUserRemittanceMasterEvent();
}

class CreateCollectedRemittanceMasterEvent extends MobileTransactionEvent{
  final BuildContext context;
  final VoidCallback refresh2;
  const CreateCollectedRemittanceMasterEvent(this.context, this.refresh2);
}

class SyncUnremittedDonationEvent extends MobileTransactionEvent{
  final BuildContext context;
  const SyncUnremittedDonationEvent(this.context);
}

class SyncUnremittedDonationCOEvent extends MobileTransactionEvent{
  const SyncUnremittedDonationCOEvent();
}

class UpdateCollectorRemittanceAyannahEvent extends MobileTransactionEvent{
  const UpdateCollectorRemittanceAyannahEvent();
}

class UpdateCollectorRemittanceBrigadahanHeadQuarterEvent extends MobileTransactionEvent{
  const UpdateCollectorRemittanceBrigadahanHeadQuarterEvent();
}