import 'package:kabrigadan_mobile/src/domain/entities/donations/donation_item/donation_item_entity.dart';

class DonationsItemModel extends DonationItemEntity{
  const DonationsItemModel({amountDonated, recipient, fundraisingId, dateTimeDonated}) : super(amountDonated, recipient, fundraisingId, dateTimeDonated);

  factory DonationsItemModel.fromJson(Map<String, dynamic> json){
    return DonationsItemModel(
      amountDonated: json['amountDonated'] as double?,
      recipient: json['recipient'] as String?,
      fundraisingId: json['fundraisingId'] as String?,
      dateTimeDonated: json['dateTimeDonated'] as String?,
    );
  }
}