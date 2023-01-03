import 'get_member_unremitted_donation_offline.dart';

class SuperGetMemberUnremittedDonationOfflineModel{
  final GetMemberUnremittedDonationOfflineModel? createMemberUnremittedDonationOfflineModel;

  SuperGetMemberUnremittedDonationOfflineModel({this.createMemberUnremittedDonationOfflineModel});

  factory SuperGetMemberUnremittedDonationOfflineModel.fromJson(Map<String, dynamic> json){
    return SuperGetMemberUnremittedDonationOfflineModel(
        createMemberUnremittedDonationOfflineModel: GetMemberUnremittedDonationOfflineModel.fromJson(json['result'])
    );
  }
}