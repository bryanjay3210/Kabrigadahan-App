import 'package:kabrigadan_mobile/src/data/models/donations/donations_model.dart';

class SuperDonationsModel{
  final DonationsModel? donations;

  SuperDonationsModel({this.donations});

  factory SuperDonationsModel.fromJson(Map<String, dynamic> json){
    return SuperDonationsModel(
      donations: DonationsModel.fromJson(json['result'])
    );
  }
}