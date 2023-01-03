import 'dart:core';

class AuthParams{
  final String userNameOrEmailAddress;
  final String password;
  final bool isOfficerOnMemberApp;

  AuthParams({required this.userNameOrEmailAddress, required this.password, required this.isOfficerOnMemberApp});

  factory AuthParams.fromJson(Map<String, dynamic> json){
    return AuthParams(
      userNameOrEmailAddress: json['user'] as String,
      password: json['password'] as String,
      isOfficerOnMemberApp: json['isOfficerOnMemberApp'] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userNameOrEmailAddress': userNameOrEmailAddress,
      'password': password,
      'isOfficerOnMemberApp': isOfficerOnMemberApp
    };
  }
}