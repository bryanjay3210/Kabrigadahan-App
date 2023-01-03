import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/core/usecases/usecase.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising/fundraising_item_fundraising.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/fundraising/fundraising_repository.dart';

class GetFundraisingUseCase implements UseCase<DataState<List<FundraisingItemFundraising>>, int?> {
  final FundraisingRepository _fundraisingRepository;

  GetFundraisingUseCase(this._fundraisingRepository);

  @override
  Future<DataState<List<FundraisingItemFundraising>>> call({int? params, String? query}) {
    return _fundraisingRepository.getFundraising(params, query);
  }
}