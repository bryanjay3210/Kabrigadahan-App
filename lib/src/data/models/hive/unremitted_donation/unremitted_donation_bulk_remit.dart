import 'package:hive/hive.dart';

part 'unremitted_donation_bulk_remit.g.dart';
@HiveType(typeId: 14)
class UnremittedDonationBulkRemit{
  @HiveField(0)
  final String? id;

  @HiveField(1, defaultValue: '')
  String? transactionType;

  UnremittedDonationBulkRemit({this.id, this.transactionType});

  factory UnremittedDonationBulkRemit.fromJson(Map<String, dynamic> json) {
    return UnremittedDonationBulkRemit(
      id: json['id'] as String?,
      transactionType: json['transactionType'] as String?
    );
  }
}