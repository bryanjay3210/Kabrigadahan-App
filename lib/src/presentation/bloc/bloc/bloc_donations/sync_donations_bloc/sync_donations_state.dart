part of 'sync_donations_bloc.dart';

abstract class SyncDonationsState extends Equatable {
  final List<UnremittedDonationFromServer> listUnremittedDonationServer;
  final bool noMoreData;
  const SyncDonationsState({this.listUnremittedDonationServer = const <UnremittedDonationFromServer>[], this.noMoreData = false});

  @override
  List<Object> get props => [listUnremittedDonationServer];
}

class SyncDonationsInitial extends SyncDonationsState {
  const SyncDonationsInitial();
}

class SyncLoadingDonationsState extends SyncDonationsState{
  const SyncLoadingDonationsState();
}

class SyncDoneDonorDonationState extends SyncDonationsState{
  const SyncDoneDonorDonationState(List<UnremittedDonationFromServer> listUnremittedDonationServer, bool noMoreData) : super(listUnremittedDonationServer: listUnremittedDonationServer, noMoreData: noMoreData);
}

class SyncDoneCODonationState extends SyncDonationsState{
  const SyncDoneCODonationState();
}
