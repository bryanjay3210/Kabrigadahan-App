// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fundraising.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fundraising _$FundraisingFromJson(Map<String, dynamic> json) => Fundraising(
      json['totalCount'] as int?,
      (json['items'] as List<dynamic>?)
          ?.map((e) =>
              FundraisingItemFundraising.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FundraisingToJson(Fundraising instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'items': instance.items,
    };
