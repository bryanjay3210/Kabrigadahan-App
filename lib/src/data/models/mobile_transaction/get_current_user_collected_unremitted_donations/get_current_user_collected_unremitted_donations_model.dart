import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/member_unremitted_donation_model/member_unremitted_donation_model.dart';

class GetCurrentUserCollectedUnremittedDonationsModel{
  final int? totalCount;
  final List<MemberUnremittedDonationModel>? listMemberUnremittedDonationModel;

  GetCurrentUserCollectedUnremittedDonationsModel({this.totalCount, this.listMemberUnremittedDonationModel});

  factory GetCurrentUserCollectedUnremittedDonationsModel.fromJson(Map<String, dynamic> json){
    return GetCurrentUserCollectedUnremittedDonationsModel(
      totalCount: json['totalCount'],
      listMemberUnremittedDonationModel: List<MemberUnremittedDonationModel>.from(
          (json['items'] as List<dynamic>).map((e) => MemberUnremittedDonationModel.fromJson(e as Map<String, dynamic>)))
    );
  }
}