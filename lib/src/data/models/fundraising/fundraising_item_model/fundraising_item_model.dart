import 'package:kabrigadan_mobile/src/data/models/fundraising/specific_fundraise_model/specific_fundraise_model.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising/fundraising_item.dart';

class FundraisingItemModel extends FundraisingItem{
  const FundraisingItemModel({
    fundraising,
    fundRaiser,
    approvedBy,
    communityOfficer,
    verifiedBy,
    fundraisingBatchName
  }) : super(
    fundraising,
    fundRaiser,
    approvedBy,
    communityOfficer,
    verifiedBy,
    fundraisingBatchName
  );

  factory FundraisingItemModel.fromJson(Map<String, dynamic> json) {
    return FundraisingItemModel(
        fundraising: SpecificFundraiseModel.fromJson(json['fundraising']),
        fundRaiser: json['fundRaiser'],
        approvedBy: json['approvedBy'],
        communityOfficer: json['communityOfficer'],
        verifiedBy: json['verifiedBy'],
        fundraisingBatchName: json['fundraisingBatchName'],
    );
  }
}