import '../domain/app_notification.dart';
import 'notifications_repository.dart';

class MockNotificationsRepository implements NotificationsRepository {
  final List<ParkoNotification> _items = [
    ParkoNotification(
      id: 'n1',
      title: 'Reservation confirmed',
      body: 'The Avenues Mall · today 6:00 PM',
      category: 'reservation',
      read: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ParkoNotification(
      id: 'n2',
      title: 'Spot opening soon',
      body: '360 Mall predicted to ease around 4:30 PM',
      category: 'prediction',
      read: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    ParkoNotification(
      id: 'n3',
      title: '5 KWD wallet credit',
      body: 'Parko Points redemption applied',
      category: 'wallet',
      read: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Future<NotificationFeed> fetchFeed() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final unread = _items.where((n) => !n.read).length;
    return NotificationFeed(unreadCount: unread, items: List.from(_items));
  }

  @override
  Future<void> markRead(String id) async {
    final i = _items.indexWhere((n) => n.id == id);
    if (i < 0) return;
    final old = _items[i];
    _items[i] = ParkoNotification(
      id: old.id,
      title: old.title,
      body: old.body,
      category: old.category,
      read: true,
      createdAt: old.createdAt,
    );
  }

  @override
  Future<NotificationFeed> markAllRead() async {
    for (var i = 0; i < _items.length; i++) {
      final old = _items[i];
      _items[i] = ParkoNotification(
        id: old.id,
        title: old.title,
        body: old.body,
        category: old.category,
        read: true,
        createdAt: old.createdAt,
      );
    }
    return fetchFeed();
  }

  @override
  Future<NotificationFeed> dismiss(String id) async {
    _items.removeWhere((n) => n.id == id);
    return fetchFeed();
  }

  @override
  Future<NotificationFeed> clearRead() async {
    _items.removeWhere((n) => n.read);
    return fetchFeed();
  }
}
