part of 'mobile_transaction_update_bloc.dart';

abstract class MobileTransactionUpdateState extends Equatable {
  const MobileTransactionUpdateState();

  @override
  List<Object?> get props => [];
}

class MobileTransactionUpdateInitial extends MobileTransactionUpdateState {
  @override
  List<Object> get props => [];
}

class RemitLoadingMobileTransactionState extends MobileTransactionUpdateState{
  const RemitLoadingMobileTransactionState();
}

class RemitDoneMobileTransactionStateDone extends MobileTransactionUpdateState{
  const RemitDoneMobileTransactionStateDone();
}
