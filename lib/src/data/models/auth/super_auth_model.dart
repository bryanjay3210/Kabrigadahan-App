import 'package:kabrigadan_mobile/src/data/models/auth/auth_model.dart';

class SuperAuthModel{
  final AuthModel? result;

  SuperAuthModel({this.result});

  factory SuperAuthModel.fromJson(Map<String, dynamic> json) {
    return SuperAuthModel(
      result: AuthModel.fromJson(json['result'])
    );
  }
}