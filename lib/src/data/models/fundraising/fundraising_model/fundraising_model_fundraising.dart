import 'package:kabrigadan_mobile/src/data/models/fundraising/fundraising_item_model/fundraising_item_model.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising/fundraising_item_fundraising.dart';

class FundraisingModelFundRaising extends FundraisingItemFundraising{
  const FundraisingModelFundRaising({
    homeFeedResultType, fundRaising
  }) : super(
      homeFeedResultType, fundRaising
  );

  factory FundraisingModelFundRaising.fromJson(Map<String, dynamic> json) {
    return FundraisingModelFundRaising(
        homeFeedResultType: json['homeFeedResultType'] as int?,
        fundRaising: FundraisingItemModel.fromJson(json['fundRaising'])
    );
  }
}