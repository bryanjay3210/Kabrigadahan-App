// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donation_item_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonationItemEntity _$DonationItemEntityFromJson(Map<String, dynamic> json) =>
    DonationItemEntity(
      (json['amountDonated'] as num?)?.toDouble(),
      json['recipient'] as String?,
      json['fundraisingId'] as String?,
      json['dateTimeDonated'] as String?,
    );

Map<String, dynamic> _$DonationItemEntityToJson(DonationItemEntity instance) =>
    <String, dynamic>{
      'amountDonated': instance.amountDonated,
      'recipient': instance.recipient,
      'fundraisingId': instance.fundraisingId,
      'dateTimeDonated': instance.dateTimeDonated,
    };
