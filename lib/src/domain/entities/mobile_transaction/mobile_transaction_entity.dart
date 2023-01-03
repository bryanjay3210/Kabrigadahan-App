import 'package:equatable/equatable.dart';

class MobileTransactionEntity extends Equatable{
  final List<String>? unremittedDonationIds;

  const MobileTransactionEntity({this.unremittedDonationIds});

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}