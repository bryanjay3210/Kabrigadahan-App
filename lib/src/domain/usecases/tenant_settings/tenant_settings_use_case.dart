import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/core/usecases/usecase.dart';
import 'package:kabrigadan_mobile/src/domain/entities/tenant_settings/tenant_settings_entity.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/tenant_settings/tenant_settings_repository.dart';

class TenantSettingsUseCase implements UseCase<DataState<TenantSettingsEntity>, void>{
  final TenantSettingsRepository tenantSettingsRepository;

  TenantSettingsUseCase(this.tenantSettingsRepository);

  @override
  Future<DataState<TenantSettingsEntity>> call({void params}) {
    return tenantSettingsRepository.getTenantSettings();
  }
}