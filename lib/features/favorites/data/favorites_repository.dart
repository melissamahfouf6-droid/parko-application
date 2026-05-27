import 'package:dio/dio.dart';

import '../domain/saved_lot.dart';

abstract class FavoritesRepository {
  Future<List<SavedLot>> fetchAll();
  Future<bool> isSaved(String lotId);
  Future<void> save({
    required String lotId,
    required String lotName,
    required double lat,
    required double lng,
  });
  Future<void> remove(String lotId);
}

class MockFavoritesRepository implements FavoritesRepository {
  static final List<SavedLot> _items = [];

  @override
  Future<List<SavedLot>> fetchAll() async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return List.from(_items);
  }

  @override
  Future<bool> isSaved(String lotId) async {
    return _items.any((e) => e.lotId == lotId);
  }

  @override
  Future<void> save({
    required String lotId,
    required String lotName,
    required double lat,
    required double lng,
  }) async {
    if (_items.any((e) => e.lotId == lotId)) return;
    _items.insert(
      0,
      SavedLot(
        id: 'mock-$lotId',
        lotId: lotId,
        lotName: lotName,
        lat: lat,
        lng: lng,
        savedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> remove(String lotId) async {
    _items.removeWhere((e) => e.lotId == lotId);
  }
}

class ApiFavoritesRepository implements FavoritesRepository {
  ApiFavoritesRepository({
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
  Future<List<SavedLot>> fetchAll() async {
    final res = await _dio.get<Map<String, dynamic>>(
      '$_base/api/favorites',
      options: Options(headers: _headers),
    );
    final list = res.data?['favorites'] as List<dynamic>? ?? [];
    return list
        .map((e) => SavedLot.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<bool> isSaved(String lotId) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '$_base/api/favorites/check/$lotId',
      options: Options(headers: _headers),
    );
    return res.data?['saved'] == true;
  }

  @override
  Future<void> save({
    required String lotId,
    required String lotName,
    required double lat,
    required double lng,
  }) async {
    await _dio.post<Map<String, dynamic>>(
      '$_base/api/favorites',
      data: {'lotId': lotId, 'lotName': lotName, 'lat': lat, 'lng': lng},
      options: Options(headers: _headers),
    );
  }

  @override
  Future<void> remove(String lotId) async {
    await _dio.delete<Map<String, dynamic>>(
      '$_base/api/favorites/$lotId',
      options: Options(headers: _headers),
    );
  }
}
