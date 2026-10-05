import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/config/app_flavor_provider.dart';
import 'package:school_erp/app/config/environment_config.dart';
import 'package:school_erp/core/errors/app_exception.dart';
import 'package:school_erp/core/network/api_page.dart';
import 'package:school_erp/core/session/session_controller.dart';
import 'package:school_erp/core/storage/token_storage.dart';
import 'package:school_erp/core/time/clock.dart';

typedef Json = Map<String, dynamic>;

/// The single entry point for HTTP calls. Features call it from data sources
/// only — never from widgets.
///
/// Understands the backend envelope `{status, message, code, data}` and
/// returns `data`; everything else becomes an [AppException].
final class ApiClient {
  ApiClient({
    required Uri baseUrl,
    required TokenStorage tokenStorage,
    required Clock clock,
    required void Function() onUnauthorized,
    bool logRequests = false,
    HttpClientAdapter? adapter,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl.toString(),
           connectTimeout: const Duration(seconds: 15),
           receiveTimeout: const Duration(seconds: 30),
           headers: {'Accept': 'application/json'},
         ),
       ) {
    if (adapter != null) _dio.httpClientAdapter = adapter;
    _dio.interceptors.add(
      _AuthInterceptor(tokenStorage: tokenStorage, clock: clock, onUnauthorized: onUnauthorized),
    );
    if (logRequests) _dio.interceptors.add(_RedactingLogInterceptor());
  }

  final Dio _dio;

  Future<Object?> get(String path, {Map<String, Object?>? query}) async =>
      (await _send(() => _dio.get<Object?>(path, queryParameters: query)))['data'];

  /// Fetches page [page] (1-based) of a paginated list endpoint (`?pageNo=`).
  Future<ApiPage> getPage(String path, {int page = 1, Map<String, Object?>? query}) async {
    final body = await _send(
      () => _dio.get<Object?>(path, queryParameters: {...?query, 'pageNo': page}),
    );
    return ApiPage.fromEnvelope(body['data'], body['pagination']);
  }

  Future<Object?> post(String path, {Map<String, Object?>? query, Object? body}) async =>
      (await _send(
        () => _dio.post<Object?>(path, queryParameters: query, data: body),
      ))['data'];

  /// Sends the request and returns the whole envelope once `status` is true.
  Future<Json> _send(Future<Response<Object?>> Function() request) async {
    final Response<Object?> response;
    try {
      response = await request();
    } on DioException catch (error) {
      throw _map(error);
    }
    final body = response.data;
    if (body is! Json) throw const ParsingException('Response is not a JSON object');
    if (body['status'] != true) {
      throw ServerException(
        message: body['message'] as String?,
        statusCode: int.tryParse('${body['code']}'),
      );
    }
    return body;
  }

  static AppException _map(DioException error) {
    final inner = error.error;
    if (inner is AppException) return inner;
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => NetworkException(error.message),
      DioExceptionType.badResponse when error.response?.statusCode == 401 =>
        const UnauthorizedException(),
      DioExceptionType.badResponse => ServerException(
        message: _messageOf(error.response?.data),
        statusCode: error.response?.statusCode,
      ),
      _ => NetworkException(error.message),
    };
  }

  static String? _messageOf(Object? data) => data is Json ? data['message'] as String? : null;
}

/// Adds the bearer token; ends the session when it is expired or rejected.
final class _AuthInterceptor extends Interceptor {
  _AuthInterceptor({
    required this.tokenStorage,
    required this.clock,
    required this.onUnauthorized,
  });

  final TokenStorage tokenStorage;
  final Clock clock;
  final void Function() onUnauthorized;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await tokenStorage.read();
    if (token != null) {
      if (token.isExpiredAt(clock())) {
        await _endSession();
        return handler.reject(
          DioException(requestOptions: options, error: const UnauthorizedException('expired')),
        );
      }
      options.headers['Authorization'] = 'Bearer ${token.value}';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final hadToken = err.requestOptions.headers.containsKey('Authorization');
    if (err.response?.statusCode == 401 && hadToken) await _endSession();
    handler.next(err);
  }

  Future<void> _endSession() async {
    await tokenStorage.clear();
    onUnauthorized();
  }
}

/// Development-only request log. Never prints tokens, passwords or bodies.
final class _RedactingLogInterceptor extends Interceptor {
  static const _secretQueryKeys = {'loginpass', 'password', 'otp'};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['startedAt'] = DateTime.now();
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _log(response.requestOptions, response.statusCode);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log(err.requestOptions, err.response?.statusCode, error: err.type.name);
    handler.next(err);
  }

  void _log(RequestOptions options, int? status, {String? error}) {
    final started = options.extra['startedAt'] as DateTime?;
    final ms = started == null ? '?' : DateTime.now().difference(started).inMilliseconds;
    final query = options.queryParameters.map(
      (key, value) =>
          MapEntry(key, _secretQueryKeys.contains(key.toLowerCase()) ? '***' : '$value'),
    );
    developer.log(
      '${options.method} ${options.path} $query → ${status ?? error} (${ms}ms)',
      name: 'api',
    );
  }
}

/// Available when the environment has an API URL; otherwise features use mock data.
final apiClientProvider = Provider<ApiClient?>((ref) {
  final config = ref.watch(environmentConfigProvider);
  final baseUrl = config.apiBaseUrl;
  if (baseUrl == null) return null;
  return ApiClient(
    baseUrl: baseUrl,
    tokenStorage: ref.watch(tokenStorageProvider),
    clock: ref.watch(clockProvider),
    onUnauthorized: () => ref.read(sessionProvider.notifier).expired(),
    logRequests: !ref.watch(appFlavorProvider).environment.isProduction,
  );
});
