part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final DioError? error;
  const AuthState({this.error});

  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState{
  const AuthLoading();
}

class MemberAuthenticated extends AuthState{
  const MemberAuthenticated();
}

class CommunityOfficerAuthenticated extends AuthState{
  const CommunityOfficerAuthenticated();
}

class Unauthenticated extends AuthState{
  const Unauthenticated();
}

class AuthError extends AuthState{
  const AuthError(DioError error) : super(error: error);
}