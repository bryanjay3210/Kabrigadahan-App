class CollectedRemittanceMasterModel{
  final String? referenceNumber;
  final double? amount;
  final String? collectorMemberId;
  final int? status;
  final String? completedDate;
  final String? id;

  CollectedRemittanceMasterModel({this.referenceNumber, this.amount, this.collectorMemberId, this.status, this.completedDate, this.id});

  factory CollectedRemittanceMasterModel.fromJson(Map<String, dynamic> json){
    return CollectedRemittanceMasterModel(
      referenceNumber: json['referenceNumber'] as String?,
      amount: json['amount'] as double?,
      collectorMemberId: json['collectorMemberId'] as String?,
      status: json['status'] as int?,
      completedDate: json['completedDate'] as String?,
      id: json['id'] as String?,
    );
  }

}