import 'package:kabrigadan_mobile/src/domain/entities/mobile_version/mobile_setting_entity.dart';

import 'mobile_version/mobile_version_model.dart';

class MobileAppUpdateModel extends MobileSettingEntity{
  const MobileAppUpdateModel({mobileVersionEntity}) : super(mobileVersionEntity);

  factory MobileAppUpdateModel.fromJson(Map<String, dynamic> json){
    return MobileAppUpdateModel(
        mobileVersionEntity: MobileVersionModel.fromJson(json['androidVersion'])
    );
  }
}