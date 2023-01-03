import 'package:kabrigadan_mobile/src/data/models/fundraising_attachment/fundraising_attachment/fundraiser_model/member/fundraiser_member_model.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising_attachment/fundraiser/fundraiser.dart';

class FundraiserModel extends Fundraiser {
  const FundraiserModel({member, barangayName, purokName, religionName, userName})
      : super(member, barangayName, purokName, religionName, userName);

  factory FundraiserModel.fromJson(Map<String, dynamic> json){
    return FundraiserModel(
        member: FundraiserMemberModel.fromJson(json['member']),
        barangayName: json['barangayName'] as String?,
        purokName: json['purokName'] as String?,
        religionName: json['religionName'] as String?,
        userName: json['userName'] as String?
    );
  }
}