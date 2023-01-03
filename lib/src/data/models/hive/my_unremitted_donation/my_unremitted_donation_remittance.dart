import 'package:hive/hive.dart';

part 'my_unremitted_donation_remittance.g.dart';

@HiveType(typeId: 12)
class MyUnremittedDonationRemittance{

  @HiveField(0)
  final double? amount;

  @HiveField(1)
  final String? referenceNumber;

  @HiveField(2)
  final String? communityOfficeIdNumber;

  @HiveField(3)
  final String? communityOfficeName;

  @HiveField(4)
  final String? communityOfficeMemberId;

  @HiveField(5)
  final String? memberRemittanceMasterID;

  @HiveField(6)
  String? transactionType;

  MyUnremittedDonationRemittance({this.amount, this.referenceNumber, this.communityOfficeIdNumber, this.communityOfficeName, this.communityOfficeMemberId, this.memberRemittanceMasterID, this.transactionType});

  factory MyUnremittedDonationRemittance.fromJson(Map<String, dynamic> json){
    return MyUnremittedDonationRemittance(
        amount: json['amount'] as double?,
        referenceNumber: json['referenceNumber'] as String?,
        communityOfficeIdNumber: json['communityOfficeIdNumber'] as String?,
        communityOfficeName: json['communityOfficeName'] as String?,
        communityOfficeMemberId: json['communityOfficeMemberId'] as String?,
        memberRemittanceMasterID: json['memberRemittanceMasterID'] as String?,
        transactionType: json['transactionType'] as String?,
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "amount": amount,
        "referenceNumber": referenceNumber,
        "communityOfficeIdNumber": communityOfficeIdNumber,
        "communityOfficeName":  communityOfficeName,
        "communityOfficeMemberId": communityOfficeMemberId,
        "memberRemittanceMasterID": memberRemittanceMasterID,
        "transactionType": transactionType,
      };

}