import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_version/mobile_setting_entity.dart';

abstract class MobileVersionRepository{
  ///GET BRIGADAHAN FUNDS CODE
  Future<DataState<MobileSettingEntity>> getMobileVersion();
}