import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/core/usecases/usecase.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/fundraising/fundraising_repository.dart';

class GetTotalCountUseCase implements UseCase<DataState<int>, void> {
  final FundraisingRepository _fundraisingRepository;

  GetTotalCountUseCase(this._fundraisingRepository);

  @override
  Future<DataState<int>> call({params}) {
    return _fundraisingRepository.getTotalCount();
  }
}