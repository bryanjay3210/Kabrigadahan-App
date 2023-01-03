part of 'mobile_transaction_update_bloc.dart';

abstract class MobileTransactionUpdateEvent extends Equatable {
  const MobileTransactionUpdateEvent();
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class MobileTransactionInitialEvent extends MobileTransactionUpdateEvent{
  const MobileTransactionInitialEvent();
}

class RemitMobileTransactionEvent extends MobileTransactionUpdateEvent{
  final MobileTransactionParams mobileTransactionParams;
  final BuildContext context;
  final List<RemittedDonation> toBeRemittedList;
  final VoidCallback refresh;
  final bool hasCached;
  const RemitMobileTransactionEvent({required this.mobileTransactionParams, required this.context, required this.toBeRemittedList, required this.refresh, required this.hasCached});
}
