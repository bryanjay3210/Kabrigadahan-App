import 'package:flutter/material.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/member_unremitted_donation_results.dart';

class ShowMemberRemittanceMasterHelper{
  static ValueNotifier<List<MemberUnremittedDonationResultsEntity>> listMemberMasters = ValueNotifier<List<MemberUnremittedDonationResultsEntity>>([]);
}