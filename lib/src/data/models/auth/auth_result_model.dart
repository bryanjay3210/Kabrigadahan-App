import 'package:kabrigadan_mobile/src/domain/entities/auth/auth_result.dart';

class AuthResultModel extends AuthResultEntity{
  const AuthResultModel({accessToken, userId}) : super(accessToken, userId);

  factory AuthResultModel.fromJson(Map<String, dynamic> json){
    return AuthResultModel(
      accessToken: json['accessToken'] as String?,
      userId: json['userId'] as int?,
    );
  }
}