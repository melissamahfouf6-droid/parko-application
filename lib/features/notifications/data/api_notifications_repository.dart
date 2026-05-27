import 'package:dio/dio.dart';

import '../domain/app_notification.dart';
import 'notifications_repository.dart';

class ApiNotificationsRepository implements NotificationsRepository {
  ApiNotificationsRepository({required Dio dio, required String baseUrl, required String userId})
      : _dio = dio,
        _base = baseUrl.replaceAll(RegExp(r'/$'), ''),
        _userId = userId;

  final Dio _dio;
  final String _base;
  final String _userId;

  Map<String, String> get _headers => {'x-user-id': _userId};

  @override
  Future<NotificationFeed> fetchFeed() async {
    final res = await _dio.get<Map<String, dynamic>>(
      '$_base/api/notifications',
      options: Options(headers: _headers),
    );
    return NotificationFeed.fromJson(Map<String, dynamic>.from(res.data ?? {}));
  }

  @override
  Future<void> markRead(String id) async {
    await _dio.post<void>(
      '$_base/api/notifications/$id/read',
      options: Options(headers: _headers),
    );
  }

  @override
  Future<NotificationFeed> markAllRead() async {
    final res = await _dio.post<Map<String, dynamic>>(
      '$_base/api/notifications/read-all',
      options: Options(headers: _headers),
    );
    return NotificationFeed.fromJson(Map<String, dynamic>.from(res.data ?? {}));
  }

  @override
  Future<NotificationFeed> dismiss(String id) async {
    await _dio.delete<void>(
      '$_base/api/notifications/$id',
      options: Options(headers: _headers),
    );
    return fetchFeed();
  }

  @override
  Future<NotificationFeed> clearRead() async {
    final res = await _dio.post<Map<String, dynamic>>(
      '$_base/api/notifications/clear-read',
      options: Options(headers: _headers),
    );
    return NotificationFeed.fromJson(Map<String, dynamic>.from(res.data ?? {}));
  }
}
