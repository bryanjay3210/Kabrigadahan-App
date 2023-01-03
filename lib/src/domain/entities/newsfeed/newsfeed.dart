import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising/fundraising_item_fundraising.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising_attachment/fundraising_attachment.dart';

part 'newsfeed.g.dart';

@JsonSerializable()
class NewsFeed extends Equatable{
  final FundraisingItemFundraising? fundraisingItem;
  final FundraisingAttachment? fundraisingAttachment;

  const NewsFeed(this.fundraisingItem, this.fundraisingAttachment);

  @override
  List<Object?> get props => [fundraisingItem, fundraisingAttachment];

  @override
  bool? get stringify => true;

  factory NewsFeed.fromJson(Map<String, dynamic> json) => _$NewsFeedFromJson(json);
  Map<String, dynamic> toJson() => _$NewsFeedToJson(this);
}