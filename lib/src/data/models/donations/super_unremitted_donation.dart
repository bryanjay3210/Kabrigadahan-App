import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/member_unremitted_donation_model/member_unremitted_donation_model.dart';

class GetMemberUnremittedDonationOfflineModel {
  final List<MemberUnremittedDonationModel>? memberUnremittedDonationList;

  GetMemberUnremittedDonationOfflineModel({this.memberUnremittedDonationList});

  factory GetMemberUnremittedDonationOfflineModel.fromJson(Map<String, dynamic> json){
    return GetMemberUnremittedDonationOfflineModel(
        memberUnremittedDonationList:
        List<MemberUnremittedDonationModel>.from(
            (json['createOrEditMemberUnRemittedDonation'] as List<dynamic>).map((e) => MemberUnremittedDonationModel.fromJson(e as Map<String, dynamic>)))
    );
  }
}