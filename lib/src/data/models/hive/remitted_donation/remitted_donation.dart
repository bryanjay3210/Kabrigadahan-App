import 'package:hive/hive.dart';

part 'remitted_donation.g.dart';

@HiveType(typeId: 3)
class RemittedDonation {
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

  @HiveField(9)
  final String? name;

  @HiveField(10)
  final DateTime? dateRecorded;

  @HiveField(11)
  final String? creatorId;

  RemittedDonation(
      {this.caseCode,
      this.amount,
      this.donatedByMemberIdNumber,
      this.agentMemberIdNumber,
      this.status,
      this.memberRemittanceMasterId,
      this.ayannahAttachment,
      this.unremittedTempId,
      this.id,
      this.name,
      this.dateRecorded,
      this.creatorId
      });

  factory RemittedDonation.fromJson(Map<String, dynamic> json) {
    return RemittedDonation(
        caseCode: json['caseCode'] as String?,
        amount: json['amount'] as double?,
        donatedByMemberIdNumber: json['donatedByMemberIdNumber'] as String?,
        agentMemberIdNumber: json['agentMemberIdNumber'] as String?,
        status: json['status'] as int?,
        memberRemittanceMasterId: json['memberRemittanceMasterId'] as String?,
        ayannahAttachment: json['ayannahAttachment'] as String?,
        unremittedTempId: json['unremittedTempId'] as String?,
        id: json['id'] as String?,
        name: json['name'] as String?,
        dateRecorded: json['dateRecorded'] as DateTime?,
        creatorId: json['creatorId'] as String?
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
        "name": name,
        "dateRecorded": dateRecorded,
        "creatorId": creatorId
      };
}
