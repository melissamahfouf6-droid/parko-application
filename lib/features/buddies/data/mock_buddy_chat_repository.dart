import '../domain/buddy_message.dart';
import 'buddy_chat_repository.dart';

class MockBuddyChatRepository implements BuddyChatRepository {
  final Map<String, List<BuddyMessage>> _threads = {};

  @override
  Future<List<BuddyMessage>> fetchMessages(String threadId) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return List<BuddyMessage>.from(_threads[threadId] ?? _seed(threadId));
  }

  @override
  Future<BuddyMessage> sendMessage({required String threadId, required String text}) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    final msg = BuddyMessage(
      id: 'local-${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      isMe: true,
      sentAt: DateTime.now(),
    );
    _threads.putIfAbsent(threadId, () => []).add(msg);
    return msg;
  }

  List<BuddyMessage> _seed(String threadId) {
    final now = DateTime.now();
    return [
      BuddyMessage(
        id: 'seed-1',
        text: 'Heading to 360 Mall around 6 PM — need 1 spot?',
        isMe: false,
        sentAt: now.subtract(const Duration(minutes: 50)),
      ),
      BuddyMessage(
        id: 'seed-2',
        text: 'Same! Happy to split parking if we find a buddy deal.',
        isMe: true,
        sentAt: now.subtract(const Duration(minutes: 48)),
      ),
    ];
  }
}
