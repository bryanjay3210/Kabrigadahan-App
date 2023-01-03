import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising/specific_fundraising.dart';

part 'fundraising_attachment_details.g.dart';

@JsonSerializable()
class FundraisingAttachmentDetails extends Equatable{
  final SpecificFundraising? fundraising;
  final String? fundRaiser;
  final String? approvedBy;
  final String? communityOfficer;
  final String? verifiedBy;

  const FundraisingAttachmentDetails(this.fundraising, this.fundRaiser, this.approvedBy, this.communityOfficer, this.verifiedBy);

  @override
  List<Object?> get props => [fundraising, fundRaiser, approvedBy, communityOfficer, verifiedBy];

  @override
  bool? get stringify => true;

  factory FundraisingAttachmentDetails.fromJson(Map<String, dynamic> json) => _$FundraisingAttachmentDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$FundraisingAttachmentDetailsToJson(this);
}
