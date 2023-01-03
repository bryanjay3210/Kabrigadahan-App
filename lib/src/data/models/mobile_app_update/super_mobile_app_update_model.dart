import 'mobile_app_update_model.dart';

class SuperMobileAppUpdateModel {
  final MobileAppUpdateModel? mobileAppUpdateModel;

  SuperMobileAppUpdateModel({this.mobileAppUpdateModel});

  factory SuperMobileAppUpdateModel.fromJson(Map<String, dynamic> json){
    return SuperMobileAppUpdateModel(
        mobileAppUpdateModel: MobileAppUpdateModel.fromJson(json['result'])
    );
  }
}