import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_remittance_master_status/remittancer_master_status.dart';

class SuperRemittanceMasterStatus {
  final List<RemittanceMasterStatus>? remittanceMasterStatus;

  SuperRemittanceMasterStatus({this.remittanceMasterStatus});

  factory SuperRemittanceMasterStatus.fromJson(Map<String, dynamic> json){
    return SuperRemittanceMasterStatus(
      remittanceMasterStatus: List<RemittanceMasterStatus>.from(
          (json['result'] as List<dynamic>).map((e) => RemittanceMasterStatus.fromJson(e as Map<String, dynamic>)))
    );
  }
}