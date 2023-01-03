import 'create_member_unremitted_donation_offline_model.dart';

class SuperCreateMemberUnremittedDonationOfflineModel{
  final CreateMemberUnremittedDonationOfflineModel? createMemberUnremittedDonationOfflineModel;

  SuperCreateMemberUnremittedDonationOfflineModel({this.createMemberUnremittedDonationOfflineModel});

  factory SuperCreateMemberUnremittedDonationOfflineModel.fromJson(Map<String, dynamic> json){
    return SuperCreateMemberUnremittedDonationOfflineModel(
      createMemberUnremittedDonationOfflineModel: CreateMemberUnremittedDonationOfflineModel.fromJson(json['result'])
    );
  }
}