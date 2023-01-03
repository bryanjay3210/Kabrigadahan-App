// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fundraising_item_fundraising.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FundraisingItemFundraising _$FundraisingItemFundraisingFromJson(
        Map<String, dynamic> json) =>
    FundraisingItemFundraising(
      json['homeFeedResultType'] as int?,
      json['fundRaising'] == null
          ? null
          : FundraisingItem.fromJson(
              json['fundRaising'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FundraisingItemFundraisingToJson(
        FundraisingItemFundraising instance) =>
    <String, dynamic>{
      'homeFeedResultType': instance.homeFeedResultType,
      'fundRaising': instance.fundRaising,
    };
