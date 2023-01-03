part of 'fundraising_bloc.dart';

abstract class FundraisingEvent extends Equatable {
  const FundraisingEvent();

  @override
  List<Object> get props => [];
}

class GetFundraising extends FundraisingEvent {
  const GetFundraising();
}

class LoadFundraising extends FundraisingEvent {
  const LoadFundraising();
}
