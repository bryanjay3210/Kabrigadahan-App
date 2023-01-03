import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/create_collected_remittance_master_params/create_collected_remittance_master_params.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/update_collector_remittance_ayannah/update_collector_remittance_ayannah.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/update_collector_remittance_brigadahan_headquarters/update_collector_remittance_brigadahan_headquarters.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/get_preferences.dart';
import 'package:kabrigadan_mobile/src/data/datasources/remote/mobile_transaction/mobile_transaction_api_service.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_current_user_collected_unremitted_donations/get_current_user_collected_unremitted_donations_model.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_current_user_remittance_master/get_current_user_remittance_master.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/get_remittance_master_status/remittancer_master_status.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/create_unpaid_collected_remittance_master/create_unpaid_collected_remittance_master.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/member_unremitted_donation_model/member_unremitted_donation_model.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/member_unremitted_donation_results.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/unpaid_remittance_master.dart';
import 'package:kabrigadan_mobile/src/domain/repositories/mobile_transaction/mobile_transaction_repository.dart';
import 'package:logger/logger.dart';

class MobileTransactionRepositoryImpl extends MobileTransactionRepository {
  final MobileTransactionApiService _mobileTransactionApiService;

  MobileTransactionRepositoryImpl(this._mobileTransactionApiService);

  @override
  Future<DataState<UnpaidRemittanceMasterEntity>> createUnpaidRemittance(String? accessToken, String? agentMemberId, List<String>? memberUnRemittedDonations) async {
    var logger = Logger();

    List<Map<String, dynamic>> parsedJsonList = [];
    for (var i in memberUnRemittedDonations!) {
      var jsonData = jsonDecode(i);
      parsedJsonList.add(jsonData);
    }

    // String? accessToken = await GetPreferences().getStoredAccessToken();

    logger.i('agent member is ' + agentMemberId.toString());
    logger.i('member donations is ' + parsedJsonList.toString());
    logger.i('accesstoken is ' + accessToken.toString());

    try {
      final httpResponse = await _mobileTransactionApiService.createUnpaidRemittance(accessToken, agentMemberId, parsedJsonList);

      logger.i(httpResponse.response);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data.unpaidRemittanceMasterModel!);
      }

      return DataFailed(DioError(error: httpResponse.response.statusMessage, response: httpResponse.response, requestOptions: httpResponse.response.requestOptions, type: DioErrorType.response));
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> updateCollectorAgentMasterRemittance(String? masterRemittanceId, String? collectorAgentId) async {
    var logger = Logger();
    String? accessToken = await GetPreferences().getStoredAccessToken();
    String? accessTokenRes = 'Bearer $accessToken';

    try {
      final httpResponse = await _mobileTransactionApiService.updateCollectorAgentMasterRemittance(accessTokenRes, masterRemittanceId, collectorAgentId);

      logger.i(httpResponse);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      }

      return DataFailed(DioError(error: httpResponse.response.statusMessage, response: httpResponse.response, requestOptions: httpResponse.response.requestOptions, type: DioErrorType.response));
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<MemberUnremittedDonationResultsEntity>>> createMemberUnRemittedDonationForOffline(List<Map<String, dynamic>>? createOrEditMemberUnRemittedDonation) async {
    try {
      String? accessToken = await GetPreferences().getStoredAccessToken();
      String? accessTokenRes = 'Bearer $accessToken';
      final httpResponse = await _mobileTransactionApiService.createMemberUnRemittedDonationForOffline(accessTokenRes, createOrEditMemberUnRemittedDonation);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data.createMemberUnremittedDonationOfflineModel!.memberUnremittedDonationList!);
      }

      return DataFailed(DioError(error: httpResponse.response.statusMessage, response: httpResponse.response, requestOptions: httpResponse.response.requestOptions, type: DioErrorType.response));
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<MemberUnremittedDonationResultsEntity>>> getRemittanceMasterDonationDetails(String? accessToken, String? memberRemittanceMasterId) async {
    try {
      final httpResponse = await _mobileTransactionApiService.getRemittanceMasterDonationDetails(accessToken, memberRemittanceMasterId);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data.listMemberUnremittedDonationModel!);
      }

      return DataFailed(DioError(error: httpResponse.response.statusMessage, response: httpResponse.response, requestOptions: httpResponse.response.requestOptions, type: DioErrorType.response));
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<RemittanceMasterStatus>>> getRemittanceMasterStatus(String? accessToken, List<String>? memberRemittanceMasterId) async {
    try {
      final httpResponse = await _mobileTransactionApiService.getRemittanceMastersStatus(accessToken, memberRemittanceMasterId);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data.remittanceMasterStatus!);
      }

      return DataFailed(DioError(error: httpResponse.response.statusMessage, response: httpResponse.response, requestOptions: httpResponse.response.requestOptions, type: DioErrorType.response));
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<GetCurrentUserRemittanceMaster>> getCurrentUserRemittanceMaster(String? accessToken) async {
    String? accessToken = await GetPreferences().getStoredAccessToken();
    String? accessTokenRes = 'Bearer $accessToken';

    try {
      final httpResponse = await _mobileTransactionApiService.getCurrentUserRemittanceMaster(accessTokenRes);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data.getCurrentUserRemittanceMaster!);
      }

      return DataFailed(DioError(error: httpResponse.response.statusMessage, response: httpResponse.response, requestOptions: httpResponse.response.requestOptions, type: DioErrorType.response));
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<GetCurrentUserRemittanceMaster>> getCurrentUserRemittanceMasterInProgress(String? accessToken) async {
    String? accessToken = await GetPreferences().getStoredAccessToken();
    String? accessTokenRes = 'Bearer $accessToken';

    try {
      final httpResponse = await _mobileTransactionApiService.getCurrentUserRemittanceMasterInProgress(accessTokenRes);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data.getCurrentUserRemittanceMaster!);
      }

      return DataFailed(DioError(error: httpResponse.response.statusMessage, response: httpResponse.response, requestOptions: httpResponse.response.requestOptions, type: DioErrorType.response));
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<GetCurrentUserRemittanceMaster>> getCurrentUserRemittanceMasterCompleted(String? accessToken) async {
    String? accessToken = await GetPreferences().getStoredAccessToken();
    String? accessTokenRes = 'Bearer $accessToken';

    try {
      final httpResponse = await _mobileTransactionApiService.getCurrentUserRemittanceMasterCompleted(accessTokenRes);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data.getCurrentUserRemittanceMaster!);
      }

      return DataFailed(DioError(error: httpResponse.response.statusMessage, response: httpResponse.response, requestOptions: httpResponse.response.requestOptions, type: DioErrorType.response));
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> updateMasterRemittancePaidInAyannah(String? masterRemittanceId, String? transactionId, String? receiptFileAttachment) async {
    String? accessToken = await GetPreferences().getStoredAccessToken();
    String? accessTokenRes = 'Bearer $accessToken';

    try {
      final httpResponse = await _mobileTransactionApiService.updateMasterRemittancePaidInAyannah(accessTokenRes, masterRemittanceId, transactionId, receiptFileAttachment);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      }

      return DataFailed(DioError(error: httpResponse.response.statusMessage, response: httpResponse.response, requestOptions: httpResponse.response.requestOptions, type: DioErrorType.response));
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<GetCurrentUserCollectedUnremittedDonationsModel>> getCurrentUserCollectedUnremittedDonations(String? accessToken) async {
    String? accessToken = await GetPreferences().getStoredAccessToken();
    String? accessTokenRes = 'Bearer $accessToken';

    try {
      final httpResponse = await _mobileTransactionApiService.getCurrentUserCollectedUnremittedDonations(accessTokenRes, 1);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        int totalCount = httpResponse.data.getCurrentUserCollectedUnremittedDonationsModel!.totalCount!;
        final httpRealResponse = await _mobileTransactionApiService.getCurrentUserCollectedUnremittedDonations(accessTokenRes, totalCount);

        if (httpRealResponse.response.statusCode == HttpStatus.ok) {
          return DataSuccess(httpRealResponse.data.getCurrentUserCollectedUnremittedDonationsModel!);
        }

        return DataFailed(DioError(error: httpResponse.response.statusMessage, response: httpResponse.response, requestOptions: httpResponse.response.requestOptions, type: DioErrorType.response));
      }

      return DataFailed(DioError(error: httpResponse.response.statusMessage, response: httpResponse.response, requestOptions: httpResponse.response.requestOptions, type: DioErrorType.response));
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<CreateUnpaidCollectedRemittanceMasterModel>> createUnpaidCollectedRemittanceMaster(CreateCollectedRemittanceMasterParams createCollectedRemittanceMasterParams) async {
    var logger = Logger();
    try {
      final httpResponse = await _mobileTransactionApiService.createUnpaidCollectedRemittanceMaster(createCollectedRemittanceMasterParams.authorizationHeader, createCollectedRemittanceMasterParams.collectorMemberId);

      logger.i(httpResponse);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data.createUnpaidCollectedRemittanceMasterModel!);
      }

      return DataFailed(DioError(error: httpResponse.response.statusMessage, response: httpResponse.response, requestOptions: httpResponse.response.requestOptions, type: DioErrorType.response));
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> updateCollectorRemittanceAyannah(UpdateCollectorRemittanceAyannahParams updateCollectorRemittanceAyannahParams) async {
    String? accessToken = await GetPreferences().getStoredAccessToken();
    String? accessTokenRes = 'Bearer $accessToken';

    try {
      final httpResponse = await _mobileTransactionApiService.updateCollectorRemittanceAyannah(accessTokenRes, updateCollectorRemittanceAyannahParams.collectedRemittanceMasterId);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      }

      return DataFailed(DioError(error: httpResponse.response.statusMessage, response: httpResponse.response, requestOptions: httpResponse.response.requestOptions, type: DioErrorType.response));
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> updateCollectorRemittanceBrigadahanHeadQuarter(UpdateCollectorRemittanceBrigadahanHeadquartersParams updateCollectorRemittanceBrigadahanHeadquartersParams) async {
    String? accessToken = await GetPreferences().getStoredAccessToken();
    String? accessTokenRes = 'Bearer $accessToken';

    try {
      final httpResponse = await _mobileTransactionApiService.updateCollectorRemittanceBrigadahanHeadQuarter(accessTokenRes, updateCollectorRemittanceBrigadahanHeadquartersParams.collectedRemittanceMasterId);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      }

      return DataFailed(DioError(error: httpResponse.response.statusMessage, response: httpResponse.response, requestOptions: httpResponse.response.requestOptions, type: DioErrorType.response));
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }
}
