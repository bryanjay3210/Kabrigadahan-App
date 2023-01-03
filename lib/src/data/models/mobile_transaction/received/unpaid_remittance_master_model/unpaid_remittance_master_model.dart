import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/member_unremitted_donation_model/member_unremitted_donation_model.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/unpaid_remittance_master.dart';

class UnpaidRemittanceMasterModel extends UnpaidRemittanceMasterEntity {
  const UnpaidRemittanceMasterModel({memberRemittanceMasterId, amount, status, referenceNumber, memberUnRemittedDonationResults, notIncluded})
      : super(memberRemittanceMasterId, amount, status, referenceNumber, memberUnRemittedDonationResults, notIncluded);

  factory UnpaidRemittanceMasterModel.fromJson(Map<String, dynamic> json) {
    return UnpaidRemittanceMasterModel(
        memberRemittanceMasterId: json['memberRemittanceMasterId'] as String?,
        amount: json['amount'] as double?,
        status: json['status'] as int?,
        referenceNumber: json['referenceNumber'] as String?,
        memberUnRemittedDonationResults:
            List<MemberUnremittedDonationModel>.from(
            (json['memberUnRemittedDonationResults'] as List<dynamic>).map((e) => MemberUnremittedDonationModel.fromJson(e as Map<String, dynamic>))),
        notIncluded:
        List<MemberUnremittedDonationModel>.from(
            (json['notIncluded'] as List<dynamic>).map((e) => MemberUnremittedDonationModel.fromJson(e as Map<String, dynamic>))),
    );
  }
}
