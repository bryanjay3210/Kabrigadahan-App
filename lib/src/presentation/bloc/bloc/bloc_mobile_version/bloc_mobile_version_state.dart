part of 'bloc_mobile_version_bloc.dart';

abstract class MobileVersionState extends Equatable {
  final DioError? error;
  const MobileVersionState({this.error});

  @override
  List<Object?> get props => [];
}

class GetMobileVersionState extends MobileVersionState {
  const GetMobileVersionState();
}

class GetMobileVersionDone extends MobileVersionState {
  const GetMobileVersionDone();
}

class AuthError extends MobileVersionState{
  const AuthError(DioError error) : super(error: error);
}
