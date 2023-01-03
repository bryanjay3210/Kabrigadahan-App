import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/get_unremitted_entities.dart';

class GetMemberUnremittedDonationModel extends GetUnremittedEntities {
  const GetMemberUnremittedDonationModel({caseCode, amount, donatedByMemberIdNumber, agentMemberIdNumber, status, memberRemittanceMasterId, ayannahAttachment, unremittedTempId, id})
      : super(caseCode, amount, donatedByMemberIdNumber, agentMemberIdNumber, status, memberRemittanceMasterId, ayannahAttachment, unremittedTempId, id);

  factory GetMemberUnremittedDonationModel.fromJson(Map<String, dynamic> json){
    return GetMemberUnremittedDonationModel(
        caseCode: json['caseCode'] as String?,
        amount: double.parse(json['amount'].toString()),
        donatedByMemberIdNumber: json['donatedByMemberIdNumber'] as String?,
        agentMemberIdNumber: json['agentMemberIdNumber'] as String?,
        status: json['status'] as int?,
        memberRemittanceMasterId: json['memberRemittanceMasterId'] as String?,
        ayannahAttachment: json['ayannahAttachment'] as String?,
        unremittedTempId: json['unremittedTempId'] as String?,
        id: json['id'] as String?
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
    "id": id
  };
}