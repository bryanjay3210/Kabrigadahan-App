// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_app_update_api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _MobileVersionApiService implements MobileVersionApiService {
  _MobileVersionApiService(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://gensan-staging.brigadahan.org';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<SuperMobileAppUpdateModel>> getMobileVersion(
      authorizationHeader) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': authorizationHeader};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<SuperMobileAppUpdateModel>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(
                    _dio.options, '/api/services/app/Account/GetAllSettings',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SuperMobileAppUpdateModel.fromJson(_result.data!);
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
