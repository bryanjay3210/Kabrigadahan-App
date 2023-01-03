import 'package:kabrigadan_mobile/src/data/models/fundraising/specific_fundraise_model/specific_fundraise_model.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising_attachment/fundraising_attachment_details/fundraising_attachment_details.dart';

class FundraisingAttachmentDetailsModel extends FundraisingAttachmentDetails {
  const FundraisingAttachmentDetailsModel({fundraising, fundRaiser, approvedBy, communityOfficer, verifiedBy}) : super(fundraising, fundRaiser, approvedBy, communityOfficer, verifiedBy);
  
  factory FundraisingAttachmentDetailsModel.fromJson(Map<String, dynamic> json){
    return FundraisingAttachmentDetailsModel(
      fundraising: SpecificFundraiseModel.fromJson(json['fundraising']),
      fundRaiser: json['fundRaiser'] as String?,
      approvedBy: json['approvedBy'] as String?,
      communityOfficer: json['communityOfficer'] as String?,
      verifiedBy: json['verifiedBy'] as String?
    );
  }
}
