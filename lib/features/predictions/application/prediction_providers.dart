import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../../loyalty/application/loyalty_providers.dart';
import '../data/api_prediction_repository.dart';
import '../data/mock_prediction_repository.dart';
import '../data/prediction_repository.dart';
import '../domain/parking_prediction.dart';

final predictionRepositoryProvider = Provider<PredictionRepository>((ref) {
  final base = ApiConfig.parkoApiBase.trim();
  if (base.isEmpty) return MockPredictionRepository();
  return ApiPredictionRepository(
    dio: ref.watch(dioProvider),
    baseUrl: base,
    userId: ref.watch(currentUserIdProvider),
  );
});

final predictionHighlightsProvider = FutureProvider<List<ParkingPrediction>>((ref) {
  return ref.watch(predictionRepositoryProvider).homeHighlights();
});

final lotPredictionProvider = FutureProvider.family<ParkingPrediction, String>((ref, lotId) {
  return ref.watch(predictionRepositoryProvider).lotPrediction(lotId);
});

final waitlistLotIdsProvider = StateProvider<Set<String>>((ref) => {});

/// Loads server waitlist into [waitlistLotIdsProvider] when API is configured.
final waitlistSyncProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(predictionRepositoryProvider);
  try {
    final ids = await repo.listWaitlistLotIds();
    ref.read(waitlistLotIdsProvider.notifier).state = ids.toSet();
  } catch (_) {
    // Keep in-memory set on failure.
  }
});
