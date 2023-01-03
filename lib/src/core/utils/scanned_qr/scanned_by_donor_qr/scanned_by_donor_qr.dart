class ScannedByDonor{
  final String? transactionId;
  final String? officerName;
  final String? officerIdNumber;
  final String? donorIdNumber;
  final String? amount;

  ScannedByDonor({this.transactionId, this.officerName, this.officerIdNumber, this.amount, this.donorIdNumber});

  factory ScannedByDonor.fromJson(Map<String, dynamic> json){
    return ScannedByDonor(
      transactionId: json['transactionId'] as String?,
      officerName: json['officerName'] as String?,
        officerIdNumber: json['officerIdNumber'] as String?,
        donorIdNumber: json['donorIdNumber'] as String?,
      amount: json['amount'] as String?
    );
  }
}