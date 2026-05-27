import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/app_notification.dart';

enum NotificationInboxFilter { all, reservation, parking, wallet, prediction, share }

final notificationFilterProvider =
    StateProvider<NotificationInboxFilter>((ref) => NotificationInboxFilter.all);

List<ParkoNotification> filterNotifications(
  List<ParkoNotification> items,
  NotificationInboxFilter filter,
) {
  if (filter == NotificationInboxFilter.all) return items;
  return items.where((n) {
    switch (filter) {
      case NotificationInboxFilter.reservation:
        return n.category == 'reservation' || n.category == 'reminder';
      case NotificationInboxFilter.parking:
        return n.category == 'parking';
      case NotificationInboxFilter.wallet:
        return n.category == 'wallet';
      case NotificationInboxFilter.prediction:
        return n.category == 'prediction';
      case NotificationInboxFilter.share:
        return n.category == 'share';
      case NotificationInboxFilter.all:
        return true;
    }
  }).toList();
}
