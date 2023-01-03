import 'package:kabrigadan_mobile/src/core/params/current_user/current_user_params.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/core/usecases/usecase.dart';
import 'package:kabrigadan_mobile/src/domain/entities/current_user/current_user_entity.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/current_user/current_user_repository.dart';

class GetCurrentUserUseCase implements UseCase<DataState<CurrentUserEntity>, CurrentUserParams?> {
  final CurrentUserRepository _currentUserRepository;

  GetCurrentUserUseCase(this._currentUserRepository);

  @override
  Future<DataState<CurrentUserEntity>> call({CurrentUserParams? params}) {
    return _currentUserRepository.getCurrentUser(params);
  }
}