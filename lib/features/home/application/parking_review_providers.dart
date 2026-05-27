import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../../loyalty/application/loyalty_providers.dart';
import '../../notifications/application/notifications_providers.dart';
import '../data/parking_review_repository.dart';
import 'home_providers.dart';

final parkingReviewRepositoryProvider = Provider<ParkingReviewRepository>((ref) {
  final base = ApiConfig.parkoApiBase.trim();
  if (base.isEmpty) return MockParkingReviewRepository();
  return ApiParkingReviewRepository(
    dio: ref.watch(dioProvider),
    baseUrl: base,
    userId: ref.watch(currentUserIdProvider),
  );
});

final parkingReviewControllerProvider = Provider<ParkingReviewController>((ref) {
  return ParkingReviewController(ref);
});

class ParkingReviewController {
  ParkingReviewController(this._ref);

  final Ref _ref;

  Future<LotReviewResult> submit({
    required String lotId,
    required int stars,
    String? comment,
  }) async {
    final result = await _ref.read(parkingReviewRepositoryProvider).submitReview(
          lotId: lotId,
          stars: stars,
          comment: comment,
        );
    _ref.invalidate(nearbyLotsProvider);
    _ref.invalidate(notificationFeedProvider);
    try {
      await _ref.read(loyaltyControllerProvider.notifier).earnReview(reference: lotId);
    } catch (_) {}
    return result;
  }
}
