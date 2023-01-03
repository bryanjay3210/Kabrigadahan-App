class MemberRemittanceMastersModel{
  final String? agentMemberId;
  final String? referenceNumber;
  final int? status;
  final String? transactionId;
  final int? transactionSourceType;
  final bool? isVerified;
  final String? isVerifiedTransactionDate;
  final double? amount;
  final String? collectorAgentId;
  final String? collectedDate;
  final int? paidById;
  final String? paidDate;
  final double? agentIncentiveAmount;
  final String? id;

  MemberRemittanceMastersModel({this.agentMemberId, this.referenceNumber, this.status, this.transactionId, this.transactionSourceType, this.isVerified, this.isVerifiedTransactionDate, this.amount, this.collectorAgentId, this.collectedDate, this.paidById, this.paidDate, this.id, this.agentIncentiveAmount});

  factory MemberRemittanceMastersModel.fromJson(Map<String, dynamic> json){
    return MemberRemittanceMastersModel(
      agentMemberId: json['agentMemberId'] as String?,
      referenceNumber: json['referenceNumber'] as String?,
      status: json['status'] as int?,
      transactionId: json['transactionId'] as String?,
      transactionSourceType: json['transactionSourceType'] as int?,
      isVerified: json['isVerified'] as bool?,
      isVerifiedTransactionDate: json['isVerifiedTransactionDate'] as String?,
      amount: json['amount'] as double?,
      collectorAgentId: json['collectorAgentId'] as String?,
      collectedDate: json['collectedDate'] as String?,
      paidById: json['paidById'] as int?,
      paidDate: json['paidDate'] as String?,
      agentIncentiveAmount: json['agentIncentiveAmount'] as double?,
      id: json['id'] as String?,
    );
  }


}