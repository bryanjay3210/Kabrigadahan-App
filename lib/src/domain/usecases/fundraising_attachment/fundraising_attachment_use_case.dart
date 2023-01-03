import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/core/usecases/usecase.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising_attachment/fundraising_attachment.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/fundraising/fundraising_repository.dart';

class GetFundraisingAttachmentUseCase implements UseCase<DataState<FundraisingAttachment>, String?>{
  final FundraisingRepository _fundraisingRepository;

  GetFundraisingAttachmentUseCase(this._fundraisingRepository);

  @override
  Future<DataState<FundraisingAttachment>> call({String? params}) {
    return _fundraisingRepository.getFundraisingAttachment(params);
  }
}