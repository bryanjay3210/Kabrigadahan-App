import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/member_unremitted_donation_results.dart';

class MemberUnremittedDonationModel extends MemberUnremittedDonationResultsEntity {
  const MemberUnremittedDonationModel({caseCode, amount, donatedByMemberIdNumber, agentMemberIdNumber, status, memberRemittanceMasterId, ayannahAttachment, unremittedTempId, id, donatedByName, agentMemberName})
      : super(caseCode, amount, donatedByMemberIdNumber, agentMemberIdNumber, status, memberRemittanceMasterId, ayannahAttachment, unremittedTempId, id, donatedByName, agentMemberName);

  factory MemberUnremittedDonationModel.fromJson(Map<String, dynamic> json){
    return MemberUnremittedDonationModel(
      caseCode: json['caseCode'] as String?,
      amount: json['amount'] != null ? double.parse(json['amount'].toString()) : null,
      donatedByMemberIdNumber: json['donatedByMemberIdNumber'] as String?,
      donatedByName: json['donatedByName'] as String?,
      agentMemberIdNumber:json['agentMemberIdNumber'] as String?,
      status: json['status'] as int?,
      memberRemittanceMasterId: json['memberRemittanceMasterId'] as String?,
      ayannahAttachment: json['ayannahAttachment'] as String?,
      unremittedTempId: json['unremittedTempId'] as String?,
      id: json['id'] as String?,
      agentMemberName: json['agentMemberName'] as String?
    );
  }

  Map<String, dynamic> toJson() => {
    "caseCode": caseCode,
    "amount": amount,
    "donatedByMemberIdNumber": donatedByMemberIdNumber,
    "agentMemberIdNumber": agentMemberIdNumber,
    "status": status,
    "memberRemittanceMasterId": memberRemittanceMasterId,
    "ayannahAttachment": ayannahAttachment,
    "unremittedTempId": unremittedTempId,
    "id": id,
    "donatedByName": donatedByName,
    "agentMemberName": agentMemberName
  };
}
