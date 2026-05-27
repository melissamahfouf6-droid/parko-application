import 'package:dio/dio.dart';

import '../domain/parking_buddy.dart';
import 'buddies_repository.dart';

class ApiBuddiesRepository implements BuddiesRepository {
  ApiBuddiesRepository({required Dio dio, required String baseUrl, required String userId})
      : _dio = dio,
        _base = baseUrl.replaceAll(RegExp(r'/$'), ''),
        _userId = userId;

  final Dio _dio;
  final String _base;
  final String _userId;

  Map<String, String> get _headers => {'x-user-id': _userId};

  @override
  Future<List<ParkingBuddy>> findNearby(String destination) async {
    final res = await _dio.get<List<dynamic>>(
      '$_base/api/buddies/nearby',
      queryParameters: {'destination': destination},
      options: Options(headers: _headers),
    );
    return (res.data ?? []).map((e) => ParkingBuddy.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> joinBuddySearch(String destination, {String? displayName}) async {
    await _dio.post(
      '$_base/api/buddies/join',
      data: {'destination': destination, if (displayName != null) 'displayName': displayName},
      options: Options(headers: _headers),
    );
  }
}
