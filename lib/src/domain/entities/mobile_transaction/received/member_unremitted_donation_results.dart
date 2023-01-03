import 'package:equatable/equatable.dart';

class MemberUnremittedDonationResultsEntity extends Equatable {
  final String? caseCode;
  final double? amount;
  final String? donatedByMemberIdNumber;
  final String? agentMemberIdNumber;
  final int? status;
  final String? memberRemittanceMasterId;
  final String? ayannahAttachment;
  final String? unremittedTempId;
  final String? id;
  final String? donatedByName;
  final String? agentMemberName;

  const MemberUnremittedDonationResultsEntity(
      this.caseCode, this.amount, this.donatedByMemberIdNumber, this.agentMemberIdNumber, this.status, this.memberRemittanceMasterId, this.ayannahAttachment, this.unremittedTempId, this.id, this.donatedByName, this.agentMemberName);

  @override
  List<Object?> get props => [caseCode, amount, donatedByMemberIdNumber, agentMemberIdNumber, status, memberRemittanceMasterId, ayannahAttachment, unremittedTempId, id, donatedByName, agentMemberName];

  @override
  bool? get stringify => true;
}
