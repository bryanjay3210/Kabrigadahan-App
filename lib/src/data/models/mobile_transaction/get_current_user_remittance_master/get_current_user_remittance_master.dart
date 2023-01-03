import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_current_user_remittance_master/get_current_user_remittance_items.dart';

class GetCurrentUserRemittanceMaster{
  final int? totalCount;
  final List<GetCurrentUserRemittanceItems>? getCurrentUserRemittanceItems;

  GetCurrentUserRemittanceMaster({this.totalCount, this.getCurrentUserRemittanceItems});

  factory GetCurrentUserRemittanceMaster.fromJson(Map<String, dynamic> json){
    return GetCurrentUserRemittanceMaster(
      totalCount: json['totalCount'] as int?,
      getCurrentUserRemittanceItems: List<GetCurrentUserRemittanceItems>.from(
          (json['items'] as List<dynamic>).map((e) => GetCurrentUserRemittanceItems.fromJson(e as Map<String, dynamic>)))
    );
  }
}