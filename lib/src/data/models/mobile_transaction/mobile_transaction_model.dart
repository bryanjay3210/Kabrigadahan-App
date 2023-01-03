import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/mobile_transaction_entity.dart';

class MobileTransactionModel extends MobileTransactionEntity{
  const MobileTransactionModel({unremittedDonationsIds}) : super(unremittedDonationIds: unremittedDonationsIds);

  factory MobileTransactionModel.fromJson(Map<String, dynamic> json){
    return MobileTransactionModel(
      unremittedDonationsIds: json['result']
    );
  }
}