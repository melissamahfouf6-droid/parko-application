import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../../loyalty/application/loyalty_providers.dart';
import '../data/api_notifications_repository.dart';
import '../data/mock_notifications_repository.dart';
import '../data/notifications_repository.dart';
import '../domain/app_notification.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  final base = ApiConfig.parkoApiBase.trim();
  if (base.isEmpty) return MockNotificationsRepository();
  return ApiNotificationsRepository(
    dio: ref.watch(dioProvider),
    baseUrl: base,
    userId: ref.watch(currentUserIdProvider),
  );
});

final notificationFeedProvider = FutureProvider<NotificationFeed>((ref) {
  return ref.watch(notificationsRepositoryProvider).fetchFeed();
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  return ref.watch(notificationFeedProvider).valueOrNull?.unreadCount ?? 0;
});

final notificationsControllerProvider = Provider<NotificationsController>((ref) {
  return NotificationsController(ref);
});

class NotificationsController {
  NotificationsController(this._ref);

  final Ref _ref;

  Future<void> markRead(String id) async {
    await _ref.read(notificationsRepositoryProvider).markRead(id);
    _ref.invalidate(notificationFeedProvider);
  }

  Future<void> markAllRead() async {
    await _ref.read(notificationsRepositoryProvider).markAllRead();
    _ref.invalidate(notificationFeedProvider);
  }

  Future<void> dismiss(String id) async {
    await _ref.read(notificationsRepositoryProvider).dismiss(id);
    _ref.invalidate(notificationFeedProvider);
  }

  Future<void> clearRead() async {
    await _ref.read(notificationsRepositoryProvider).clearRead();
    _ref.invalidate(notificationFeedProvider);
  }
}
