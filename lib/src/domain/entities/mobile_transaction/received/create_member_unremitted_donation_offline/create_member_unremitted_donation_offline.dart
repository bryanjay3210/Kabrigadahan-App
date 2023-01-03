import 'package:equatable/equatable.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/member_unremitted_donation_results.dart';

class CreateMemberUnremittedDonationOfflineEntity extends Equatable{
  final List<MemberUnremittedDonationResultsEntity>? memberUnRemittedDonationResults;

  const CreateMemberUnremittedDonationOfflineEntity(this.memberUnRemittedDonationResults);

  @override
  List<Object?> get props => [memberUnRemittedDonationResults];

  @override
  bool? get stringify => true;
}