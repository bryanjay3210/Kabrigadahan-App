import 'package:equatable/equatable.dart';

class GetUnremittedEntities extends Equatable {
  final String? caseCode;
  final double? amount;
  final String? donatedByMemberIdNumber;
  final String? agentMemberIdNumber;
  final int? status;
  final String? memberRemittanceMasterId;
  final String? ayannahAttachment;
  final String? unremittedTempId;
  final String? id;

  const GetUnremittedEntities(this.caseCode, this.amount, this.donatedByMemberIdNumber, this.agentMemberIdNumber, this.status, this.memberRemittanceMasterId, this.ayannahAttachment, this.unremittedTempId, this.id);

  @override
  List<Object?> get props => [caseCode, amount, donatedByMemberIdNumber, agentMemberIdNumber, status, memberRemittanceMasterId, ayannahAttachment, unremittedTempId, id];

  @override
  bool? get stringify => true;
}