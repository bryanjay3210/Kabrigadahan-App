import 'package:kabrigadan_mobile/src/core/params/donations/get_unremitted_donation_current_user_params.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/core/usecases/usecase.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/get_member_unremitted_donation_offline/get_member_unremitted_donation_offline_model.dart';
import 'package:kabrigadan_mobile/src/domain/entities/donations/donations_entity.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/donations/donations_repository.dart';

class GetDonationsUseCase implements UseCase<DataState<DonationsEntity>, String?> {
  final DonationsRepository? _donationsRepository;

  GetDonationsUseCase(this._donationsRepository);

  @override
  Future<DataState<DonationsEntity>> call({String? params}) {
    return _donationsRepository!.getCurrentUser(params);
  }

}

class GetCurrentUnRemittedUseCase implements UseCase<DataState<List<GetMemberUnremittedDonationModel>>, GetUnremittedDonationsCurrentUserParams?> {
  final DonationsRepository? _donationsRepository;

  GetCurrentUnRemittedUseCase(this._donationsRepository);

  @override
  Future<DataState<List<GetMemberUnremittedDonationModel>>> call({GetUnremittedDonationsCurrentUserParams? params}) {
    return _donationsRepository!.getUnRemittedDonationCurrentUser(params);
  }

}