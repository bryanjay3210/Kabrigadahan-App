import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_current_user_collected_unremitted_donations/get_current_user_collected_unremitted_donations_model.dart';

class SuperGetCurrentUserCollectedUnremittedDonationsModel{
  final GetCurrentUserCollectedUnremittedDonationsModel? getCurrentUserCollectedUnremittedDonationsModel;

  SuperGetCurrentUserCollectedUnremittedDonationsModel({this.getCurrentUserCollectedUnremittedDonationsModel});

  factory SuperGetCurrentUserCollectedUnremittedDonationsModel.fromJson(Map<String, dynamic> json){
    return SuperGetCurrentUserCollectedUnremittedDonationsModel(
      getCurrentUserCollectedUnremittedDonationsModel: GetCurrentUserCollectedUnremittedDonationsModel.fromJson(json['result'])
    );
  }
}