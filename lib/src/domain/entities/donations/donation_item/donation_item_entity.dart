import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'donation_item_entity.g.dart';
@JsonSerializable()
class DonationItemEntity extends Equatable{
  final double? amountDonated;
  final String? recipient;
  final String? fundraisingId;
  final String? dateTimeDonated;

  const DonationItemEntity(this.amountDonated, this.recipient, this.fundraisingId, this.dateTimeDonated);

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;

  factory DonationItemEntity.fromJson(Map<String, dynamic> json) => _$DonationItemEntityFromJson(json);
  Map<String, dynamic> toJson() => _$DonationItemEntityToJson(this);
}