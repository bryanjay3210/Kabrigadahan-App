import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'fundraising_item_fundraising.dart';

part 'fundraising.g.dart';

@JsonSerializable()
class Fundraising extends Equatable{
  final int? totalCount;
  final List<FundraisingItemFundraising>? items;

  const Fundraising(this.totalCount, this.items);

  @override
  List<Object?> get props => [totalCount, items];

  @override
  bool? get stringify => true;

  factory Fundraising.fromJson(Map<String, dynamic> json) => _$FundraisingFromJson(json);
  Map<String, dynamic> toJson() => _$FundraisingToJson(this);
}