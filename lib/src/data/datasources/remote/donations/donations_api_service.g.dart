// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donations_api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _DonationsApiService implements DonationsApiService {
  _DonationsApiService(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://gensan-staging.brigadahan.org';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<SuperDonationsModel>> getDonationsCurrentUser(
      authorizationHeader) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': authorizationHeader};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<SuperDonationsModel>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options,
                    '/api/services/app/Donations/GetMobileDonationsCurrentUser',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SuperDonationsModel.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<SuperGetMemberUnremittedDonationOfflineModel>>
      getUnRemittedDonationsCurrentUser(authorizationHeader,
          checkStatusOfExistingDonationIds, skipCount) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'CheckStatusOfExistingDonationIds': checkStatusOfExistingDonationIds,
      r'SkipCount': skipCount
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': authorizationHeader};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        HttpResponse<SuperGetMemberUnremittedDonationOfflineModel>>(Options(
            method: 'GET', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/api/services/app/MobileTransaction/GetCurrentUserUnremittedDonations',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value =
        SuperGetMemberUnremittedDonationOfflineModel.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
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
