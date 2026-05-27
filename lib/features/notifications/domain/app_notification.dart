class ParkoNotification {
  const ParkoNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.read,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final String category;
  final bool read;
  final DateTime createdAt;

  factory ParkoNotification.fromJson(Map<String, dynamic> json) {
    return ParkoNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      category: json['category'] as String? ?? 'info',
      read: json['read'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class NotificationFeed {
  const NotificationFeed({required this.unreadCount, required this.items});

  final int unreadCount;
  final List<ParkoNotification> items;

  factory NotificationFeed.fromJson(Map<String, dynamic> json) {
    return NotificationFeed(
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => ParkoNotification.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
