import 'package:equatable/equatable.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/member_unremitted_donation_results.dart';

class UnpaidRemittanceMasterEntity extends Equatable{
  final String? memberRemittanceMasterId;
  final double? amount;
  final int? status;
  final String? referenceNumber;
  final List<MemberUnremittedDonationResultsEntity>? memberUnRemittedDonationResults;
  final List<MemberUnremittedDonationResultsEntity>? notIncluded;

  const UnpaidRemittanceMasterEntity(this.memberRemittanceMasterId, this.amount, this.status, this.referenceNumber, this.memberUnRemittedDonationResults, this.notIncluded);

  @override
  List<Object?> get props => [memberRemittanceMasterId, amount, status, referenceNumber, memberUnRemittedDonationResults, notIncluded];

  @override
  bool? get stringify => true;
}