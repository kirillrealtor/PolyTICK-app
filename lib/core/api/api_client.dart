import 'package:dio/dio.dart';
import 'package:polytick_app/config/api_config.dart';
import 'package:polytick_app/core/api/api_interceptors.dart';
import 'package:polytick_app/core/auth/token_storage.dart';

/// Dio HTTP client — equivalent of `clientApi.js` in Next.js.
///
/// Usage:
/// ```dart
/// final api = ApiClient.instance;
/// final response = await api.get('/trades/congress');
/// ```
class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;

  ApiClient._() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(AuthInterceptor(TokenStorage()));
    _dio.interceptors.add(ErrorInterceptor());
  }

  static ApiClient get instance {
    _instance ??= ApiClient._();
    return _instance!;
  }

  Dio get dio => _dio;

  /// Reset the singleton (e.g. on logout to clear any cached state).
  static void reset() {
    _instance?._dio.close();
    _instance = null;
  }

  // ── Convenience methods matching axios patterns ──

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Options? options,
  }) {
    return _dio.put<T>(path, data: data, options: options);
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Options? options,
  }) {
    return _dio.delete<T>(path, data: data, options: options);
  }
}
