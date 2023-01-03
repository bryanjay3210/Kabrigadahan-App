import 'package:kabrigadan_mobile/src/data/models/donations/donations_item_model.dart';
import 'package:kabrigadan_mobile/src/domain/entities/donations/donations_entity.dart';

class DonationsModel extends DonationsEntity{
  const DonationsModel({totalDonations, totalCount, items}) : super(totalDonations, totalCount, items);

  factory DonationsModel.fromJson(Map<String, dynamic> json){
    return DonationsModel(
      totalDonations: json['totalDonations'] as double?,
      totalCount: json['totalCount'] as int?,
      items: json['items'] == null ? null : List<DonationsItemModel>.from(
        (json['items'] as List<dynamic>).map((e) => DonationsItemModel.fromJson(e as Map<String, dynamic>))
      )
    );
  }
}