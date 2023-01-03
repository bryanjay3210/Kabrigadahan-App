import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/member_unremitted_donation_model/member_unremitted_donation_model.dart';

class CreateMemberUnremittedDonationOfflineModel {
  final List<MemberUnremittedDonationModel>? memberUnremittedDonationList;

  CreateMemberUnremittedDonationOfflineModel({this.memberUnremittedDonationList});

  factory CreateMemberUnremittedDonationOfflineModel.fromJson(Map<String, dynamic> json){
    return CreateMemberUnremittedDonationOfflineModel(
        memberUnremittedDonationList:
        List<MemberUnremittedDonationModel>.from(
            (json['createOrEditMemberUnRemittedDonation'] as List<dynamic>).map((e) => MemberUnremittedDonationModel.fromJson(e as Map<String, dynamic>)))
    );
  }
}