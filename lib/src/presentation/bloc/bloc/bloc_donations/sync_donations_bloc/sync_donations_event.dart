part of 'sync_donations_bloc.dart';

abstract class SyncDonationsEvent extends Equatable {
  const SyncDonationsEvent();

  @override
  List<Object?> get props => [];
}

class PostSyncDonationsDonorEvent extends SyncDonationsEvent{
  const PostSyncDonationsDonorEvent();
}

class PostSyncButtonDonationsDonorEvent extends SyncDonationsEvent{
  const PostSyncButtonDonationsDonorEvent();
}


class PostSyncDonationsCOEvent extends SyncDonationsEvent{
  const PostSyncDonationsCOEvent();
}