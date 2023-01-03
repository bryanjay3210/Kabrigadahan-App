part of 'bloc_mobile_transaction_bloc.dart';

abstract class MobileTransactionState extends Equatable {
  final String? referenceNumber;

  const MobileTransactionState({this.referenceNumber});

  @override
  List<Object?> get props => [referenceNumber];
}

class SendingMobileTransaction extends MobileTransactionState {
  const SendingMobileTransaction();
}

class SentMobileTransaction extends MobileTransactionState{
  const SentMobileTransaction(String? referenceNumber) : super(referenceNumber: referenceNumber);
}

class GetCurrentUserMasterRemittanceLoadingState extends MobileTransactionState{
  const GetCurrentUserMasterRemittanceLoadingState();
}

class GetCurrentUserMasterRemittanceDoneState extends MobileTransactionState{
  const GetCurrentUserMasterRemittanceDoneState();
}

class ErrorSentMobileTransaction extends MobileTransactionState{
  const ErrorSentMobileTransaction();
}

class SyncUnremittedDonationLoadingState extends MobileTransactionState{
  const SyncUnremittedDonationLoadingState();
}

class SyncUnremittedDonationDoneState extends MobileTransactionState{
  const SyncUnremittedDonationDoneState();
}