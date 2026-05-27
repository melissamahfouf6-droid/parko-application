import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../../loyalty/application/loyalty_providers.dart';
import '../data/api_buddy_chat_repository.dart';
import '../data/buddy_chat_repository.dart';
import '../data/mock_buddy_chat_repository.dart';
import '../domain/buddy_message.dart';

final buddyChatRepositoryProvider = Provider<BuddyChatRepository>((ref) {
  final base = ApiConfig.parkoApiBase.trim();
  if (base.isEmpty) return MockBuddyChatRepository();
  return ApiBuddyChatRepository(
    dio: ref.watch(dioProvider),
    baseUrl: base,
    userId: ref.watch(currentUserIdProvider),
  );
});

final buddyMessagesProvider =
    FutureProvider.family<List<BuddyMessage>, String>((ref, threadId) {
  return ref.watch(buddyChatRepositoryProvider).fetchMessages(threadId);
});
