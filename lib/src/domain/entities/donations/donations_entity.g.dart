// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donations_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonationsEntity _$DonationsEntityFromJson(Map<String, dynamic> json) =>
    DonationsEntity(
      (json['totalDonations'] as num?)?.toDouble(),
      json['totalCount'] as int?,
      (json['items'] as List<dynamic>?)
          ?.map((e) => DonationItemEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DonationsEntityToJson(DonationsEntity instance) =>
    <String, dynamic>{
      'totalDonations': instance.totalDonations,
      'totalCount': instance.totalCount,
      'items': instance.items,
    };
