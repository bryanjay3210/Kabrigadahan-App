import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kabrigadan_mobile/src/core/params/donations/get_unremitted_donation_current_user_params.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/data/datasources/remote/donations/donations_api_service.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/get_member_unremitted_donation_offline/get_member_unremitted_donation_offline_model.dart';
import 'package:kabrigadan_mobile/src/domain/entities/donations/donations_entity.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/donations/donations_repository.dart';

class DonationsRepositoryImpl implements DonationsRepository{
  final DonationsApiService _donationsApiService;

  DonationsRepositoryImpl(this._donationsApiService);

  @override
  Future<DataState<DonationsEntity>> getCurrentUser(String? headers) async {
    try{
      final httpResponse = await _donationsApiService.getDonationsCurrentUser(headers);

      if(httpResponse.response.statusCode == HttpStatus.ok){
        return DataSuccess(httpResponse.data.donations!);
      }

      return DataFailed(
        DioError(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          requestOptions: httpResponse.response.requestOptions,
          type: DioErrorType.response
        )
      );

    } on DioError catch(e){
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<GetMemberUnremittedDonationModel>>> getUnRemittedDonationCurrentUser(GetUnremittedDonationsCurrentUserParams? params) async {
    try{
      final httpResponse = await _donationsApiService.getUnRemittedDonationsCurrentUser(params!.header, params.checkStatusOfExistingDonationIds, params.skipCount);

      if(httpResponse.response.statusCode == HttpStatus.ok){
        return DataSuccess(httpResponse.data.createMemberUnremittedDonationOfflineModel!.memberUnremittedDonationList!);
      }

      return DataFailed(
          DioError(
              error: httpResponse.response.statusMessage,
              response: httpResponse.response,
              requestOptions: httpResponse.response.requestOptions,
              type: DioErrorType.response
          )
      );

    } on DioError catch(e){
      return DataFailed(e);
    }
  }
}