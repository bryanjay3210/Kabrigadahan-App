class GetCurrentUserRemittanceItems{
  final String? agentMemberId;
  final String? agentMemberName;
  final String? agentMemberIdNumber;
  final String? referenceNumber;
  final int? status;
  final String? transactionId;
  final int? transactionSourceType;
  final bool? isVerified;
  final String? isVerifiedTransactionDate;
  final double? amount;
  final String? collectorAgentId;
  final String? collectorAgentName;
  final String? collectedDate;
  final String? completedDate;
  final String? id;
  final String? collectorAgentIdNumber;
  final String? overideMemberRemittanceMasterId;
  final String? aoReferenceNumber;
  final double? agentIncentiveAmount;

  GetCurrentUserRemittanceItems(
      {this.agentMemberId,
      this.agentMemberName,
      this.agentMemberIdNumber,
      this.referenceNumber,
      this.status,
      this.transactionId,
      this.transactionSourceType,
      this.isVerified,
      this.isVerifiedTransactionDate,
      this.amount,
      this.collectorAgentId,
      this.collectorAgentName,
      this.collectedDate,
      this.completedDate,
      this.id,
      this.collectorAgentIdNumber,
      this.overideMemberRemittanceMasterId,
      this.aoReferenceNumber,
      this.agentIncentiveAmount
      });

  factory GetCurrentUserRemittanceItems.fromJson(Map<String, dynamic> json){
    return GetCurrentUserRemittanceItems(
      agentMemberId: json['agentMemberId'] as String?,
      agentMemberName: json['agentMemberName'] as String?,
      agentMemberIdNumber: json['agentMemberIdNumber'] as String?,
      referenceNumber: json['referenceNumber'] as String?,
      status: json['status'] as int?,
      transactionId: json['transactionId'] as String?,
      transactionSourceType: json['transactionSourceType'] as int?,
      isVerified: json['isVerified'] as bool?,
      isVerifiedTransactionDate: json['isVerifiedTransactionDate'] as String?,
      amount: json['amount'] as double?,
      collectorAgentId: json['collectorAgentId'] as String?,
      collectorAgentName: json['collectorAgentName'] as String?,
      collectedDate: json['collectedDate'] as String?,
      completedDate: json['completedDate'] as String?,
      id: json['id'] as String?,
      collectorAgentIdNumber: json['collectorAgentIdNumber'] as String?,
      overideMemberRemittanceMasterId: json['overideMemberRemittanceMasterId'] as String?,
      aoReferenceNumber: json['aoReferenceNumber'] as String?,
      agentIncentiveAmount: json['agentIncentiveAmount'] as double?
    );
  }
}