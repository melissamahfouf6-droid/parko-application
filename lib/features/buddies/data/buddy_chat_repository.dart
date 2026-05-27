import '../domain/buddy_message.dart';

abstract class BuddyChatRepository {
  Future<List<BuddyMessage>> fetchMessages(String threadId);
  Future<BuddyMessage> sendMessage({required String threadId, required String text});
}
