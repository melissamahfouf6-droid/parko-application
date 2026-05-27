class BuddyMessage {
  const BuddyMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.sentAt,
  });

  final String id;
  final String text;
  final bool isMe;
  final DateTime sentAt;

  String get timeLabel {
    final h = sentAt.hour > 12 ? sentAt.hour - 12 : (sentAt.hour == 0 ? 12 : sentAt.hour);
    final m = sentAt.minute.toString().padLeft(2, '0');
    final am = sentAt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $am';
  }

  factory BuddyMessage.fromJson(Map<String, dynamic> json, String currentUserId) {
    return BuddyMessage(
      id: json['id'] as String,
      text: json['text'] as String,
      isMe: json['senderUserId'] == currentUserId,
      sentAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
