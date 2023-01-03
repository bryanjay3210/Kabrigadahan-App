import 'package:equatable/equatable.dart';
import 'package:kabrigadan_mobile/src/domain/entities/auth/auth_result.dart';

class AuthEntity extends Equatable{
  final AuthResultEntity? authResult;
  final List<String>? permissions;

  const AuthEntity(this.authResult, this.permissions);

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}