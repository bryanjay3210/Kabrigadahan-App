import 'package:equatable/equatable.dart';

import 'mobile_version_entity.dart';

class MobileSettingEntity extends Equatable{
  final MobileVersionEntity? mobileVersionEntity;

  const MobileSettingEntity(this.mobileVersionEntity);

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}