import 'package:kabrigadan_mobile/src/data/models/auth/auth_result_model.dart';
import 'package:kabrigadan_mobile/src/domain/entities/auth/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    authResult,
    permissions
  }) : super(authResult, permissions);

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
        authResult: AuthResultModel.fromJson(json['authResult']),
        permissions: List<String>.from(
            (json['permissions'] as List<dynamic>).map((e) => e as String?)
        )
    );
  }
}
