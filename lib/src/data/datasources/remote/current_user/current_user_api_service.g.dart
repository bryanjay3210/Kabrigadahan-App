// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user_api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _CurrentUserApiService implements CurrentUserApiService {
  _CurrentUserApiService(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://gensan-staging.brigadahan.org';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<SuperCurrentUserModel>> getCurrentUser(
      authorizationHeader, userId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'id': userId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': authorizationHeader};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<SuperCurrentUserModel>>(Options(
                method: 'GET', headers: _headers, extra: _extra)
            .compose(
                _dio.options, '/api/services/app/Members/GetMemberWithUserId',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SuperCurrentUserModel.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<SuperCurrentUserProfilePictureModel>>
      getCurrentUserProfilePicture(imageTokenId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'imageTokenId': imageTokenId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<SuperCurrentUserProfilePictureModel>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(
                    _dio.options, '/api/services/app/Members/GetBinaryImage',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SuperCurrentUserProfilePictureModel.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<SuperMembersUnderCOModel>> getAllMemberByCO(
      authorizationHeader) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': authorizationHeader};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<SuperMembersUnderCOModel>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(
                    _dio.options, '/api/services/app/Members/GetAllMemberByCO',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SuperMembersUnderCOModel.fromJson(_result.data!);
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
