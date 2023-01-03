import 'package:kabrigadan_mobile/src/core/params/auth/auth_params.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/core/usecases/usecase.dart';
import 'package:kabrigadan_mobile/src/domain/entities/auth/auth_entity.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/auth/auth_repository.dart';

class GetAuthUseCase implements UseCase<DataState<AuthEntity>, AuthParams> {
  final AuthRepository _authRepository;

  GetAuthUseCase(this._authRepository);

  @override
  Future<DataState<AuthEntity>> call({AuthParams? params}) {
    return _authRepository.tokenAuth(params);
  }
}