import 'package:hive/hive.dart';

part 'area_officer_master_local.g.dart';

@HiveType(typeId: 9)
class AreaOfficerMasterLocal {
  @HiveField(0)
  final String? amount;

  @HiveField(1)
  final String? referenceNumber;

  @HiveField(2)
  final String? communityOfficeId;

  @HiveField(3)
  final String? communityOfficerName;

  @HiveField(4)
  final String? communityOfficerMemberId;

  @HiveField(5)
  final String? memberRemittanceMasterID;

  @HiveField(6)
  int? status;

  @HiveField(7)
  final bool isAreaOfficer;

  @HiveField(8)
  String? agentMemberId;

  @HiveField(9)
  String? agentMemberIdNumber;

  @HiveField(10)
  final String? creatorID;

  @HiveField(11)
  final String dateCreated;

  @HiveField(12)
  final String transactionType;

  AreaOfficerMasterLocal({
    this.amount,
    this.referenceNumber,
    required this.communityOfficeId,
    required this.communityOfficerName,
    required this.communityOfficerMemberId,
    this.memberRemittanceMasterID,
    required this.status,
    required this.isAreaOfficer,
    required this.agentMemberId,
    this.agentMemberIdNumber,
    required this.creatorID,
    required this.dateCreated,
    required this.transactionType
  });

  factory AreaOfficerMasterLocal.fromJson(Map<String, dynamic> json){
    return AreaOfficerMasterLocal(
        amount: json['amount'] as String?,
        referenceNumber: json['referenceNumber'] as String?,
        communityOfficeId: json['communityOfficeId'] as String?,
        communityOfficerName: json['communityOfficerName'] as String?,
        communityOfficerMemberId: json['communityOfficerMemberId'] as String?,
        memberRemittanceMasterID: json['memberRemittanceMasterID'] as String?,
        status: json['status'] as int?,
        isAreaOfficer: json['isAreaOfficer'] as bool,
        agentMemberId: json['agentMemberId'] as String?,
        agentMemberIdNumber: json['agentMemberIdNumber'] as String?,
        creatorID: json['creatorID'] as String?,
        dateCreated: json['dateCreated'] as String,
        transactionType: json['transactionType'] as String
    );
  }

  Map<String, dynamic> toJson() =>{
    "amount": amount,
    "referenceNumber": referenceNumber,
    "communityOfficeId": communityOfficeId,
    "communityOfficerName": communityOfficerName,
    "communityOfficerMemberId": communityOfficerMemberId,
    "memberRemittanceMasterID": memberRemittanceMasterID,
    "status": status,
    "isAreaOfficer": isAreaOfficer,
    "agentMemberId": agentMemberId,
    "agentMemberIdNumber": agentMemberIdNumber,
    "creatorID": creatorID,
    "dateCreated": dateCreated,
    "transactionType": transactionType
  };
}