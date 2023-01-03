import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/core/usecases/usecase.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_version/mobile_setting_entity.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/mobile_version/mobile_version_repository.dart';

class MobileVersionUseCase implements UseCase<DataState<MobileSettingEntity>, void>{
  final MobileVersionRepository mobileVersionRepository;

  MobileVersionUseCase(this.mobileVersionRepository);

  @override
  Future<DataState<MobileSettingEntity>> call({void params}) {
    return mobileVersionRepository.getMobileVersion();
  }
}