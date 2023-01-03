import 'package:hive/hive.dart';

part 'unremitted_donation_fromserver.g.dart';

@HiveType(typeId: 8)
class UnremittedDonationFromServer {
  @HiveField(0)
  final String? caseCode;
  @HiveField(1)
  final double? amount;
  @HiveField(2)
  final String? donatedByMemberIdNumber;
  @HiveField(3)
  final String? agentMemberIdNumber;
  @HiveField(4)
  final int? status;
  @HiveField(5)
  final String? memberRemittanceMasterId;
  @HiveField(6)
  final String? ayannahAttachment;
  @HiveField(7)
  final String? unremittedTempId;
  @HiveField(8)
  final String? id;

  UnremittedDonationFromServer({
    this.caseCode,
    this.amount,
    this.donatedByMemberIdNumber,
    this.agentMemberIdNumber,
    this.status,
    this.memberRemittanceMasterId,
    this.ayannahAttachment,
    this.unremittedTempId,
    this.id,
  });

  factory UnremittedDonationFromServer.fromJson(Map<String, dynamic> json){
    return UnremittedDonationFromServer(
      caseCode: json['caseCode'] as String?,
      amount: json['amount'] as double?,
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
