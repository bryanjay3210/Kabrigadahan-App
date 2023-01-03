import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising/specific_fundraising.dart';

part 'fundraising_item.g.dart';

@JsonSerializable()
class FundraisingItem extends Equatable{
  final SpecificFundraising? fundraising;
  final String? fundRaiser;
  final String? approvedBy;
  final String? communityOfficer;
  final String? verifiedBy;
  final String? fundraisingBatchName;
  const FundraisingItem(this.fundraising, this.fundRaiser, this.approvedBy, this.communityOfficer, this.verifiedBy, this.fundraisingBatchName);

  @override
  List<Object?> get props => [fundraising, fundRaiser, approvedBy, communityOfficer, verifiedBy, fundraisingBatchName];

  @override
  bool? get stringify => true;

  factory FundraisingItem.fromJson(Map<String, dynamic> json) => _$FundraisingItemFromJson(json);
  Map<String, dynamic> toJson() => _$FundraisingItemToJson(this);
}