import 'package:kabrigadan_mobile/src/core/params/current_user/current_user_params.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/core/usecases/usecase.dart';
import 'package:kabrigadan_mobile/src/domain/entities/current_user/current_user_entity.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/current_user/current_user_repository.dart';

class GetMemberUnderCOUseCase implements UseCase<DataState<List<CurrentUserEntity>>, CurrentUserParams?> {
  final MembersUnderCORepository _membersUnderCORepository;

  GetMemberUnderCOUseCase(this._membersUnderCORepository);

  @override
  Future<DataState<List<CurrentUserEntity>>> call({CurrentUserParams? params}) {
    return _membersUnderCORepository.getAllMemberByCO(params);
  }

}