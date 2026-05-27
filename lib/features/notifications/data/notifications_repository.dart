import '../domain/app_notification.dart';

abstract class NotificationsRepository {
  Future<NotificationFeed> fetchFeed();

  Future<void> markRead(String id);

  Future<NotificationFeed> markAllRead();

  Future<NotificationFeed> dismiss(String id);

  Future<NotificationFeed> clearRead();
}
