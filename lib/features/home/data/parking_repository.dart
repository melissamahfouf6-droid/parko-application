import 'package:dio/dio.dart';

import '../domain/parking_lot.dart';
import 'api_parking_repository.dart';

abstract class ParkingRepository {
  Future<List<ParkingLot>> nearbyLots({
    required double lat,
    required double lng,
  });
}

/// In-memory mock lots (used when [PARKO_API_BASE] is unset).
class MockParkingRepository implements ParkingRepository {
  @override
  Future<List<ParkingLot>> nearbyLots({required double lat, required double lng}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return const [
      ParkingLot(
        id: 'avenues',
        name: 'The Avenues Mall',
        lat: 29.3346,
        lng: 47.9415,
        totalSpots: 1500,
        availableSpots: 240,
        priceKwdPerHour: 1.5,
        rating: 4.6,
        reviewCount: 1240,
        hasValet: true,
        hoursLabel: '10 AM – 10 PM',
      ),
      ParkingLot(
        id: 'kuwait_uni',
        name: 'Kuwait University',
        lat: 29.3250,
        lng: 47.9726,
        totalSpots: 700,
        availableSpots: 32,
        priceKwdPerHour: 0.0,
        rating: 4.2,
        reviewCount: 310,
        hasValet: false,
        hoursLabel: '7 AM – 9 PM',
      ),
      ParkingLot(
        id: 'hospital',
        name: 'Dasman Diabetes Institute',
        lat: 29.3683,
        lng: 47.9874,
        totalSpots: 220,
        availableSpots: 9,
        priceKwdPerHour: 1.0,
        rating: 4.4,
        reviewCount: 520,
        hasValet: false,
        supportsReservation: false,
        hoursLabel: '24 hours',
      ),
      ParkingLot(
        id: '360_mall',
        name: '360 Mall',
        lat: 29.3503,
        lng: 48.0187,
        totalSpots: 800,
        availableSpots: 12,
        priceKwdPerHour: 2.0,
        rating: 4.5,
        reviewCount: 890,
        hasValet: true,
        supportsReservation: true,
        hoursLabel: '10 AM – 11 PM',
      ),
      ParkingLot(
        id: 'marina',
        name: 'Marina Mall',
        lat: 29.3461,
        lng: 48.0592,
        totalSpots: 600,
        availableSpots: 0,
        priceKwdPerHour: 1.75,
        rating: 4.3,
        reviewCount: 640,
        hasValet: true,
        supportsReservation: true,
        hoursLabel: '10 AM – 10 PM',
      ),
    ];
  }
}

/// Uses live API; falls back to [MockParkingRepository] when the server is down.
class ResilientParkingRepository implements ParkingRepository {
  ResilientParkingRepository({
    required ApiParkingRepository api,
    MockParkingRepository? mock,
  })  : _api = api,
        _mock = mock ?? MockParkingRepository();

  final ApiParkingRepository _api;
  final MockParkingRepository _mock;

  /// Set when the last [nearbyLots] call used mock data after an API failure.
  static bool lastFetchUsedOfflineFallback = false;

  @override
  Future<List<ParkingLot>> nearbyLots({
    required double lat,
    required double lng,
  }) async {
    lastFetchUsedOfflineFallback = false;
    try {
      return await _api.nearbyLots(lat: lat, lng: lng);
    } on DioException catch (e) {
      final offline = e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          (e.response == null && e.error != null);
      if (offline) {
        lastFetchUsedOfflineFallback = true;
        return _mock.nearbyLots(lat: lat, lng: lng);
      }
      rethrow;
    } catch (_) {
      lastFetchUsedOfflineFallback = true;
      return _mock.nearbyLots(lat: lat, lng: lng);
    }
  }
}

