// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fundraising_api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _FundraisingApiService implements FundraisingApiService {
  _FundraisingApiService(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://gensan-staging.brigadahan.org';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<SuperFundraisingModel>> getFundraising(
      skipCount, query) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'Skipcount': skipCount,
      r'Query': query
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<SuperFundraisingModel>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(
                    _dio.options, '/api/services/app/MobileApi/GetHomeFeeds',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SuperFundraisingModel.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<SuperFundraisingModel>> getTotalCount() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<SuperFundraisingModel>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(
                    _dio.options, '/api/services/app/MobileApi/GetHomeFeeds',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SuperFundraisingModel.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<SuperFundraisingAttachmentModel>>
      getFundraisingAttachment(fundraisingId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'fundraisingId': fundraisingId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        HttpResponse<SuperFundraisingAttachmentModel>>(Options(
            method: 'GET', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/api/services/app/MobileApi/GetMobileFundraisingsAndAttachments',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SuperFundraisingAttachmentModel.fromJson(_result.data!);
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
