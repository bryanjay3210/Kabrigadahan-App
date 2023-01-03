import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising/fundraising_item_fundraising.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising_attachment/fundraising_attachment.dart';

abstract class FundraisingRepository{
  ///API FOR FUNDRAISING
  Future<DataState<List<FundraisingItemFundraising>>> getFundraising(int? params, String? query);

  ///GET TOTAL COUNT OF FUNDRAISING
  Future<DataState<int>> getTotalCount();

  ///API FOR FUNDRAISING ATTACHMENT
  Future<DataState<FundraisingAttachment>> getFundraisingAttachment(String? fundraisingId);
}