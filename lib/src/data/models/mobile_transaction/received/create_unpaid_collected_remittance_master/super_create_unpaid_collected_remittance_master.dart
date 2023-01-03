import 'create_unpaid_collected_remittance_master.dart';

class SuperCreateUnpaidCollectedRemittanceMasterModel{
  final CreateUnpaidCollectedRemittanceMasterModel? createUnpaidCollectedRemittanceMasterModel;
  SuperCreateUnpaidCollectedRemittanceMasterModel({this.createUnpaidCollectedRemittanceMasterModel});

  factory SuperCreateUnpaidCollectedRemittanceMasterModel.fromJson(Map<String, dynamic> json){
    return SuperCreateUnpaidCollectedRemittanceMasterModel(
        createUnpaidCollectedRemittanceMasterModel: CreateUnpaidCollectedRemittanceMasterModel.fromJson(json['result']),
    );
  }

}