import 'collected_remittance_master.dart';
import 'member_remittance_masters.dart';

class CreateUnpaidCollectedRemittanceMasterModel{
  final CollectedRemittanceMasterModel? collectedRemittanceMasterModel;
  final List<MemberRemittanceMastersModel>? memberRemittanceMastersModel;

  //result
  CreateUnpaidCollectedRemittanceMasterModel({this.collectedRemittanceMasterModel, this.memberRemittanceMastersModel});

  factory CreateUnpaidCollectedRemittanceMasterModel.fromJson(Map<String, dynamic> json){
    return CreateUnpaidCollectedRemittanceMasterModel(
     collectedRemittanceMasterModel: CollectedRemittanceMasterModel.fromJson(json['collectedRemittanceMaster']),
      memberRemittanceMastersModel: List<MemberRemittanceMastersModel>.from(
    (json['memberRemittanceMasters'] as List<dynamic>).map((e) => MemberRemittanceMastersModel.fromJson(e as Map<String, dynamic>)))
    );
  }


}
