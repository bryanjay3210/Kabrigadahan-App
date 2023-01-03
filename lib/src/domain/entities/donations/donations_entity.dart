import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kabrigadan_mobile/src/domain/entities/donations/donation_item/donation_item_entity.dart';

part 'donations_entity.g.dart';

@JsonSerializable()
class DonationsEntity extends Equatable{
  final double? totalDonations;
  final int? totalCount;
  final List<DonationItemEntity>? items;

  const DonationsEntity(this.totalDonations, this.totalCount, this.items);

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;

  factory DonationsEntity.fromJson(Map<String, dynamic> json) => _$DonationsEntityFromJson(json);
  Map<String, dynamic> toJson() => _$DonationsEntityToJson(this);

}