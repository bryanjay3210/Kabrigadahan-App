import 'package:hive/hive.dart';

part 'unremitted_donation_reference.g.dart';

@HiveType(typeId: 13)
class UnremittedDonationReference {

  @HiveField(0)
  final String? referenceNumber;

  @HiveField(1)
  final String? memberRemittanceMasterId;

  @HiveField(2, defaultValue: null)
  String? transactionType;

  @HiveField(3)
  final String? collectorAgentId;

  @HiveField(4, defaultValue: 0.0)
  double? amount;

  UnremittedDonationReference({this.referenceNumber, this.memberRemittanceMasterId, this.transactionType, this.collectorAgentId, this.amount});

  factory UnremittedDonationReference.fromJson(Map<String, dynamic> json) {
    return UnremittedDonationReference(
        referenceNumber: json['referenceNumber'] as String?,
        memberRemittanceMasterId: json['memberRemittanceMasterId'] as String?,
        transactionType: json['transactionType'] as String?,
        collectorAgentId: json['collectorAgentId'] as String?,
        amount: json['amount'] as double?
    );
  }

}