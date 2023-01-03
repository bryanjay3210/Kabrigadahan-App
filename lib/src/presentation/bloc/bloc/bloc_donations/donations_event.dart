part of 'donations_bloc.dart';

abstract class DonationsEvent extends Equatable {
  const DonationsEvent();

  @override
  List<Object?> get props => [];
}

class GetDonationsEvent extends DonationsEvent{
  const GetDonationsEvent();
}

class DonationsLoadingEvent extends DonationsEvent{
  const DonationsLoadingEvent();
}
