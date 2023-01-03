import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_current_user_remittance_master/get_current_user_remittance_master.dart';

class SuperGetCurrentUserRemittanceMaster{
  final GetCurrentUserRemittanceMaster? getCurrentUserRemittanceMaster;

  SuperGetCurrentUserRemittanceMaster({this.getCurrentUserRemittanceMaster});

  factory SuperGetCurrentUserRemittanceMaster.fromJson(Map<String, dynamic> json){
    return SuperGetCurrentUserRemittanceMaster(
      getCurrentUserRemittanceMaster: GetCurrentUserRemittanceMaster.fromJson(json['result'])
    );
  }
}