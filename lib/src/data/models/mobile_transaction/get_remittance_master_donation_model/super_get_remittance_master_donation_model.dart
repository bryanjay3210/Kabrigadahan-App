import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/member_unremitted_donation_model/member_unremitted_donation_model.dart';

class SuperGetRemittanceMasterDonationModel{
  final List<MemberUnremittedDonationModel>? listMemberUnremittedDonationModel;

  SuperGetRemittanceMasterDonationModel({this.listMemberUnremittedDonationModel});

  factory SuperGetRemittanceMasterDonationModel.fromJson(Map<String, dynamic> json){
    return SuperGetRemittanceMasterDonationModel(
      listMemberUnremittedDonationModel: List<MemberUnremittedDonationModel>.from(
          (json['result'] as List<dynamic>).map((e) => MemberUnremittedDonationModel.fromJson(e as Map<String, dynamic>)))
    );
  }
}