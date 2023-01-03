import 'package:kabrigadan_mobile/src/data/models/fundraising/fundraising_model/fundraising_model.dart';

class SuperFundraisingModel{
  final FundraisingModel? result;

  const SuperFundraisingModel({this.result});

  factory SuperFundraisingModel.fromJson(Map<String, dynamic> json) {
    return SuperFundraisingModel(
      result: FundraisingModel.fromJson(json['result'])
    );
  }
}