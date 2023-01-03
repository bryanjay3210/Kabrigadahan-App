import 'get_member_unremitted_donation_offline_model.dart';

class GetMemberUnremittedDonationOfflineModel {
  final List<GetMemberUnremittedDonationModel>? memberUnremittedDonationList;

  GetMemberUnremittedDonationOfflineModel({this.memberUnremittedDonationList});

  factory GetMemberUnremittedDonationOfflineModel.fromJson(Map<String, dynamic> json){
    return GetMemberUnremittedDonationOfflineModel(
        memberUnremittedDonationList:
        json['items'] != null ?
        List<GetMemberUnremittedDonationModel>.from(
            (json['items'] as List<dynamic>).map((e) => GetMemberUnremittedDonationModel.fromJson(e as Map<String, dynamic>)))
            : null
    );
  }
}