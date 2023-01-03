import 'package:kabrigadan_mobile/src/core/params/donations/get_unremitted_donation_current_user_params.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/get_member_unremitted_donation_offline/get_member_unremitted_donation_offline_model.dart';
import 'package:kabrigadan_mobile/src/domain/entities/donations/donations_entity.dart';

abstract class DonationsRepository{
  Future<DataState<DonationsEntity>> getCurrentUser(String? headers);

  //TODO: ADD REPOSITORY FOR OFFLINE
  Future<DataState<List<GetMemberUnremittedDonationModel>>> getUnRemittedDonationCurrentUser(GetUnremittedDonationsCurrentUserParams? params);
}