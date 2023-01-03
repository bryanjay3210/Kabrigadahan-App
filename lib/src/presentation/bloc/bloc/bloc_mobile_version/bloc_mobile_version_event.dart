part of 'bloc_mobile_version_bloc.dart';

abstract class MobileVersionEvent extends Equatable {
  const MobileVersionEvent();


  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class GetMobileVersionEvent extends MobileVersionEvent{
  const GetMobileVersionEvent();
}
