import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/unpaid_remittance_master_model/unpaid_remittance_master_model.dart';

class SuperUnpaidRemittanceMasterModel {
  final UnpaidRemittanceMasterModel? unpaidRemittanceMasterModel;

  SuperUnpaidRemittanceMasterModel({this.unpaidRemittanceMasterModel});

  factory SuperUnpaidRemittanceMasterModel.fromJson(Map<String, dynamic> json){
    return SuperUnpaidRemittanceMasterModel(
      unpaidRemittanceMasterModel: UnpaidRemittanceMasterModel.fromJson(json['result'])
    );
  }

}