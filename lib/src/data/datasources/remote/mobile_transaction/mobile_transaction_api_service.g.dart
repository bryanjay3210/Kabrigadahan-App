// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_transaction_api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _MobileTransactionApiService implements MobileTransactionApiService {
  _MobileTransactionApiService(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://gensan-staging.brigadahan.org';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<SuperUnpaidRemittanceMasterModel>> createUnpaidRemittance(
      authorizationHeader, agentMemberId, memberUnRemittedDonations) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': authorizationHeader};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'agentMemberId': agentMemberId,
      'memberUnRemittedDonations': memberUnRemittedDonations
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        HttpResponse<SuperUnpaidRemittanceMasterModel>>(Options(
            method: 'POST', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/api/services/app/MobileTransaction/CreateUnpaidRemittanceMaster',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SuperUnpaidRemittanceMasterModel.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<void>> updateCollectorAgentMasterRemittance(
      authorizationHeader, masterRemittanceId, collectorAgentId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': authorizationHeader};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'masterRemittanceId': masterRemittanceId,
      'collectorAgentId': collectorAgentId
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<void>(_setStreamType<
        HttpResponse<void>>(Options(
            method: 'PUT', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/api/services/app/MobileTransaction/UpdateCollectorAgentInMasterRemittance',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final httpResponse = HttpResponse(null, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<void>> updateMasterRemittancePaidInAyannah(
      authorizationHeader,
      masterRemittanceId,
      transactionId,
      receiptFileAttachment) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': authorizationHeader};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'masterRemittanceId': masterRemittanceId,
      'transactionId': transactionId,
      'receiptFileAttachment': receiptFileAttachment
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<void>(_setStreamType<
        HttpResponse<void>>(Options(
            method: 'PUT', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/api/services/app/MobileTransaction/UpdateMasterRemittancePaidInAyannah',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final httpResponse = HttpResponse(null, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<SuperCreateMemberUnremittedDonationOfflineModel>>
      createMemberUnRemittedDonationForOffline(
          authorizationHeader, memberUnRemittedDonations) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': authorizationHeader};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'createOrEditMemberUnRemittedDonation': memberUnRemittedDonations
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        HttpResponse<SuperCreateMemberUnremittedDonationOfflineModel>>(Options(
            method: 'POST', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/api/services/app/MobileTransaction/CreateMemberUnRemittedDonationForSynching',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value =
        SuperCreateMemberUnremittedDonationOfflineModel.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<SuperGetRemittanceMasterDonationModel>>
      getRemittanceMasterDonationDetails(
          authorizationHeader, memberRemittanceMasterId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'id': memberRemittanceMasterId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': authorizationHeader};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        HttpResponse<SuperGetRemittanceMasterDonationModel>>(Options(
            method: 'GET', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/api/services/app/MobileTransaction/GetRemittanceMasterDonationDetails',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SuperGetRemittanceMasterDonationModel.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<SuperRemittanceMasterStatus>> getRemittanceMastersStatus(
      authorizationHeader, remittanceMasterId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'id': remittanceMasterId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': authorizationHeader};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        HttpResponse<SuperRemittanceMasterStatus>>(Options(
            method: 'GET', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/api/services/app/MobileTransaction/GetRemittanceMastersStatus',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SuperRemittanceMasterStatus.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<SuperGetCurrentUserRemittanceMaster>>
      getCurrentUserRemittanceMaster(authorizationHeader) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': authorizationHeader};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        HttpResponse<SuperGetCurrentUserRemittanceMaster>>(Options(
            method: 'GET', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/api/services/app/MobileTransaction/GetCurrentUserRemittanceMaster',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SuperGetCurrentUserRemittanceMaster.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<SuperGetCurrentUserRemittanceMaster>>
      getCurrentUserRemittanceMasterInProgress(authorizationHeader) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': authorizationHeader};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        HttpResponse<SuperGetCurrentUserRemittanceMaster>>(Options(
            method: 'GET', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/api/services/app/MobileTransaction/GetCurrentUserRemittanceMasterInProgress',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SuperGetCurrentUserRemittanceMaster.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<SuperGetCurrentUserRemittanceMaster>>
      getCurrentUserRemittanceMasterCompleted(authorizationHeader) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': authorizationHeader};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        HttpResponse<SuperGetCurrentUserRemittanceMaster>>(Options(
            method: 'GET', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/api/services/app/MobileTransaction/GetCurrentUserRemittanceMasterCompleted',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SuperGetCurrentUserRemittanceMaster.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<SuperGetCurrentUserCollectedUnremittedDonationsModel>>
      getCurrentUserCollectedUnremittedDonations(
          authorizationHeader, maxResultCount) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'MaxResultCount': maxResultCount
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': authorizationHeader};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
            HttpResponse<SuperGetCurrentUserCollectedUnremittedDonationsModel>>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(_dio.options,
                '/api/services/app/MobileTransaction/GetCurrentUserCollectedUnremittedDonations',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SuperGetCurrentUserCollectedUnremittedDonationsModel.fromJson(
        _result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<SuperCreateUnpaidCollectedRemittanceMasterModel>>
      createUnpaidCollectedRemittanceMaster(
          authorizationHeader, collectorMemberId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': authorizationHeader};
    _headers.removeWhere((k, v) => v == null);
    final _data = {'collectorMemberId': collectorMemberId};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        HttpResponse<SuperCreateUnpaidCollectedRemittanceMasterModel>>(Options(
            method: 'POST', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/api/services/app/MobileTransaction/CreateUnpaidCollectedRemittanceMaster',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value =
        SuperCreateUnpaidCollectedRemittanceMasterModel.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<void>> updateCollectorRemittanceAyannah(
      authorizationHeader, collectedRemittanceMasterId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': authorizationHeader};
    _headers.removeWhere((k, v) => v == null);
    final _data = {'collectedRemittanceMasterId': collectedRemittanceMasterId};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<void>(_setStreamType<
        HttpResponse<void>>(Options(
            method: 'PUT', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/api/services/app/MobileTransaction/UpdateCollectorRemittanceAyannah',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final httpResponse = HttpResponse(null, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<void>> updateCollectorRemittanceBrigadahanHeadQuarter(
      authorizationHeader, collectedRemittanceMasterId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': authorizationHeader};
    _headers.removeWhere((k, v) => v == null);
    final _data = {'collectedRemittanceMasterId': collectedRemittanceMasterId};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<void>(_setStreamType<
        HttpResponse<void>>(Options(
            method: 'PUT', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/api/services/app/MobileTransaction/UpdateCollectorRemittanceBrigadahanHeadQuarter',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final httpResponse = HttpResponse(null, _result);
    return httpResponse;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
