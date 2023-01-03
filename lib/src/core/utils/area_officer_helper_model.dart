class AreaOfficerHelperModel{
  final double? amount;
  final String? referenceNumber;
  final String? communityOfficeIdNumber;
  final String? communityOfficeName;
  final String? communityOfficeMemberId;
  final String? memberRemittanceMasterID;
  final String? agentMemberId;
  final String? agentMemberName;

  AreaOfficerHelperModel({this.amount, this.referenceNumber, this.communityOfficeIdNumber, this.communityOfficeName, this.communityOfficeMemberId, this.memberRemittanceMasterID, this.agentMemberId,
  this.agentMemberName});

  factory AreaOfficerHelperModel.fromJson(Map<String, dynamic> json){
    return AreaOfficerHelperModel(
      amount: json['amount'] as double?,
      referenceNumber: json['referenceNumber'] as String?,
      communityOfficeIdNumber: json['communityOfficeIdNumber'] as String?,
      communityOfficeName: json['communityOfficeName'] as String?,
      communityOfficeMemberId: json['communityOfficeMemberId'] as String?,
      memberRemittanceMasterID: json['memberRemittanceMasterID'] as String?,
      agentMemberId: json['agentMemberId'] as String?,
      agentMemberName: json['agentMemberName'] as String?
    );
  }
}