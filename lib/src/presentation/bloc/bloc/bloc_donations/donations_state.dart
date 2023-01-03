part of 'donations_bloc.dart';

abstract class DonationsState extends Equatable {
  final DonationsEntity? donationsEntity;

  const DonationsState({this.donationsEntity});

  @override
  List<Object?> get props => [donationsEntity];
}

class DonationsLoading extends DonationsState {
  const DonationsLoading();
}

class DonationsDone extends DonationsState {
  const DonationsDone(DonationsEntity donationsEntity):super(donationsEntity: donationsEntity);
}
