part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthUninitialized extends AuthEvent{
  const AuthUninitialized();
}

class GetAuthentication extends AuthEvent{
  final BuildContext context;
  const GetAuthentication(this.context);
}

class LoginEvent extends AuthEvent{
  final AuthParams? params;
  const LoginEvent({this.params});
}

class Logout extends AuthEvent{
  const Logout();
}