import 'package:hive/hive.dart';

part 'unremitted_donation.g.dart';

@HiveType(typeId: 1)
class UnremittedDonation {
  @HiveField(0)
  final String? caseCode;

  @HiveField(1)
  final double? amount;

  @HiveField(2)
  final String? donatedByMemberIdNumber;

  @HiveField(3)
  final String? agentMemberIdNumber;

  @HiveField(4)
  int? status;

  @HiveField(5)
  final String? memberRemittanceMasterId;

  @HiveField(6)
  final String? ayannahAttachment;

  @HiveField(7)
  final String? unremittedTempId;

  @HiveField(8)
  String? id;

  @HiveField(9)
  String? creatorId;

  @HiveField(10)
  String? referenceNumber;

  UnremittedDonation(
      {this.caseCode, this.amount, this.donatedByMemberIdNumber, this.agentMemberIdNumber, this.status, this.memberRemittanceMasterId, this.ayannahAttachment, this.unremittedTempId, this.id, this.creatorId, this.referenceNumber});

  factory UnremittedDonation.fromJson(Map<String, dynamic> json) {
    return UnremittedDonation(
        caseCode: json['caseCode'] as String?,
        amount: json['amount'] as double?,
        donatedByMemberIdNumber: json['donatedByMemberIdNumber'] as String?,
        agentMemberIdNumber: json['agentMemberIdNumber'] as String?,
        status: json['status'] as int?,
        memberRemittanceMasterId: json['memberRemittanceMasterId'] as String?,
        ayannahAttachment: json['ayannahAttachment'] as String?,
        unremittedTempId: json['unremittedTempId'] as String?,
        id: json['id'] as String?,
        creatorId: json['creatorId'] as String?,
        referenceNumber: json['referenceNumber'] as String?
    );
  }
}
