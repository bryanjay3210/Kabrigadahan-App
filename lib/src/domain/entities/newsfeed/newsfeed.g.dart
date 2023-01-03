// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'newsfeed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsFeed _$NewsFeedFromJson(Map<String, dynamic> json) => NewsFeed(
      json['fundraisingItem'] == null
          ? null
          : FundraisingItemFundraising.fromJson(
              json['fundraisingItem'] as Map<String, dynamic>),
      json['fundraisingAttachment'] == null
          ? null
          : FundraisingAttachment.fromJson(
              json['fundraisingAttachment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NewsFeedToJson(NewsFeed instance) => <String, dynamic>{
      'fundraisingItem': instance.fundraisingItem,
      'fundraisingAttachment': instance.fundraisingAttachment,
    };
