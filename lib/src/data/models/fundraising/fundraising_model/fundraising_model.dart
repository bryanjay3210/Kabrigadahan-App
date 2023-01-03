import 'package:kabrigadan_mobile/src/domain/entities/fundraising/fundraising.dart';

import 'fundraising_model_fundraising.dart';

class FundraisingModel extends Fundraising{
  const FundraisingModel({
    totalCount,
    items
  }) : super(
    totalCount,
    items
  );

  factory FundraisingModel.fromJson(Map<String, dynamic> json) {
    return FundraisingModel(
      totalCount: json['totalCount'] as int?,
      items: List<FundraisingModelFundRaising>.from(
      (json['items'] as List<dynamic>).map((e) => FundraisingModelFundRaising.fromJson(e as Map<String, dynamic>)))
    );
  }
}