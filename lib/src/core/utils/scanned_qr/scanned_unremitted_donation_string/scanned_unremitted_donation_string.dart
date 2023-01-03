class ScannedUnremittedDonationString{
  final String? donatedByMemberIdNumber;
  final String? name;
  final String? amount;
  final String? caseCode;

  ScannedUnremittedDonationString({this.donatedByMemberIdNumber, this.name, this.amount, this.caseCode});

  factory ScannedUnremittedDonationString.fromJson(Map<String, dynamic> json){
    return ScannedUnremittedDonationString(
      donatedByMemberIdNumber: json['donatedByMemberIdNumber'] as String?,
      name: json['name'] as String?,
      amount: json['amount'] as String?,
      caseCode: json['caseCode'] as String?
    );
  }
}