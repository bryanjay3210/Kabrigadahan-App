import 'package:hive/hive.dart';

part 'unremitted_donation_ui_server.g.dart';

@HiveType(typeId: 11)
class UnremittedDonationUiServer {
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
  final String? name;

  @HiveField(10)
  DateTime? dateRecorded;

  @HiveField(11)
  String? creatorId;


  UnremittedDonationUiServer(
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
        this.creatorId});

  factory UnremittedDonationUiServer.fromJson(Map<String, dynamic> json) {
    return UnremittedDonationUiServer(
        caseCode: json['caseCode'] as String?,
        amount: json['amount'] != null ? double.parse(json['amount'].toString()) : null,
        donatedByMemberIdNumber: json['donatedByMemberIdNumber'] as String?,
        agentMemberIdNumber: json['agentMemberIdNumber'] as String?,
        status: json['status'] as int?,
        memberRemittanceMasterId: json['memberRemittanceMasterId'] as String?,
        ayannahAttachment: json['ayannahAttachment'] as String?,
        unremittedTempId: json['unremittedTempId'] as String?,
        id: json['id'] as String?,
        name: json['name'] as String?,
        dateRecorded: json['dateRecorded'] as DateTime?,
        creatorId: json['creatorId'] as String?,
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
    "creatorId": creatorId,
  };

  Map<String, dynamic> toJsonSyncing() => {
    "caseCode": caseCode,
    "amount": amount,
    "donatedByMemberIdNumber": donatedByMemberIdNumber,
    "agentMemberIdNumber": agentMemberIdNumber,
    "status": status,
    "unremittedTempId": unremittedTempId,
    "id": id,
    "name": name,
    "dateRecorded": dateRecorded,
    "creatorId": creatorId,
  };
}
