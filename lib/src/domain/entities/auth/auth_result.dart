import 'package:equatable/equatable.dart';

class AuthResultEntity extends Equatable{
  final String? accessToken;
  final int? userId;

  const AuthResultEntity(this.accessToken, this.userId);

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}