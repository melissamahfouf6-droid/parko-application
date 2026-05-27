import 'package:dio/dio.dart';

import '../domain/buddy_message.dart';
import 'buddy_chat_repository.dart';

class ApiBuddyChatRepository implements BuddyChatRepository {
  ApiBuddyChatRepository({
    required Dio dio,
    required String baseUrl,
    required String userId,
  })  : _dio = dio,
        _base = baseUrl.replaceAll(RegExp(r'/$'), ''),
        _userId = userId;

  final Dio _dio;
  final String _base;
  final String _userId;

  Map<String, String> get _headers => {'x-user-id': _userId};

  @override
  Future<List<BuddyMessage>> fetchMessages(String threadId) async {
    final res = await _dio.get<List<dynamic>>(
      '$_base/api/buddies/chat/$threadId/messages',
      options: Options(headers: _headers),
    );
    return (res.data ?? [])
        .map((e) => BuddyMessage.fromJson(e as Map<String, dynamic>, _userId))
        .toList();
  }

  @override
  Future<BuddyMessage> sendMessage({required String threadId, required String text}) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '$_base/api/buddies/chat/$threadId/messages',
      data: {'text': text},
      options: Options(headers: _headers),
    );
    return BuddyMessage.fromJson(Map<String, dynamic>.from(res.data ?? {}), _userId);
  }
}
