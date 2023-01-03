import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'fundraising_item.dart';

part 'fundraising_item_fundraising.g.dart';

@JsonSerializable()
class FundraisingItemFundraising extends Equatable{
  final int? homeFeedResultType;
  final FundraisingItem? fundRaising;

  const FundraisingItemFundraising(this.homeFeedResultType, this.fundRaising);

  @override
  List<Object?> get props => [homeFeedResultType, fundRaising];

  @override
  bool? get stringify => true;

  factory FundraisingItemFundraising.fromJson(Map<String, dynamic> json) => _$FundraisingItemFundraisingFromJson(json);
  Map<String, dynamic> toJson() => _$FundraisingItemFundraisingToJson(this);
}