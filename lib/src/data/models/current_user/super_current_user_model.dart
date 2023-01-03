import 'package:kabrigadan_mobile/src/data/models/current_user/current_user_model.dart';

class SuperCurrentUserModel{
  final CurrentUserModel? currentUserModel;

  SuperCurrentUserModel({this.currentUserModel});

  factory SuperCurrentUserModel.fromJson(Map<String, dynamic> json){
    return SuperCurrentUserModel(
      currentUserModel: CurrentUserModel.fromJson(json['result'])
    );
  }
}