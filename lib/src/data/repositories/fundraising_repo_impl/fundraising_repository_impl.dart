import 'package:dio/dio.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/data/datasources/remote/fundraising/fundraising_api_service.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising/fundraising_item_fundraising.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising_attachment/fundraising_attachment.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/fundraising/fundraising_repository.dart';
import 'package:logger/logger.dart';

import 'dart:io';

class FundraisingRepositoryImpl implements FundraisingRepository{
  final FundraisingApiService _fundraisingApiService;

  FundraisingRepositoryImpl(this._fundraisingApiService);

  var logger = Logger();

  @override
  Future<DataState<List<FundraisingItemFundraising>>> getFundraising(int? skipCount, String? query) async {
    try{
      final httpResponse = await _fundraisingApiService.getFundraising(skipCount, query);

      if(httpResponse.response.statusCode == HttpStatus.ok){
        return DataSuccess(httpResponse.data.result!.items!);
      }

      return DataFailed(
        DioError(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            requestOptions: httpResponse.response.requestOptions,
            type: DioErrorType.response
        )
      );
    } on DioError catch(e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<FundraisingAttachment>> getFundraisingAttachment(String? fundraisingId) async {
    try{
      final httpResponse = await _fundraisingApiService.getFundraisingAttachment(fundraisingId);

      if(httpResponse.response.statusCode == HttpStatus.ok){
        return DataSuccess(httpResponse.data.fundraisingAttachment!);
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
  Future<DataState<int>> getTotalCount() async {
    try{
      final httpResponse = await _fundraisingApiService.getTotalCount();

      if(httpResponse.response.statusCode == HttpStatus.ok){
        return DataSuccess(httpResponse.data.result!.totalCount!);
      }

      return DataFailed(
          DioError(
              error: httpResponse.response.statusMessage,
              response: httpResponse.response,
              requestOptions: httpResponse.response.requestOptions,
              type: DioErrorType.response
          )
      );
    } on DioError catch(e) {
      return DataFailed(e);
    }
  }


}