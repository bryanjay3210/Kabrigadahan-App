class RemittanceMasterStatus{
  final String? remittanceMasterId;
  final int? status;

  RemittanceMasterStatus({this.remittanceMasterId, this.status});

  factory RemittanceMasterStatus.fromJson(Map<String, dynamic> json){
    return RemittanceMasterStatus(
      remittanceMasterId: json['remittanceMasterId'] as String?,
      status: json['status'] as int?
    );
  }
}