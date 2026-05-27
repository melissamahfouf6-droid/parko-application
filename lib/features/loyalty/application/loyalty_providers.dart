import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/application/auth_providers.dart';
import '../data/api_loyalty_repository.dart';
import '../data/loyalty_repository.dart';
import '../../wallet/application/wallet_providers.dart';
import '../data/mock_loyalty_repository.dart';
import '../domain/loyalty_models.dart';

export '../../auth/application/auth_providers.dart' show currentUserIdProvider;

final loyaltyRepositoryProvider = Provider<LoyaltyRepository>((ref) {
  final base = ApiConfig.parkoApiBase.trim();
  if (base.isEmpty) {
    return MockLoyaltyRepository();
  }
  return ApiLoyaltyRepository(
    dio: ref.watch(dioProvider),
    baseUrl: base,
    userId: ref.watch(currentUserIdProvider),
  );
});

final loyaltyControllerProvider =
    AsyncNotifierProvider<LoyaltyController, LoyaltySummary>(LoyaltyController.new);

/// True when the user has not checked in yet today (local day).
final canCheckInTodayProvider = Provider<bool>((ref) {
  final summary = ref.watch(loyaltyControllerProvider).valueOrNull;
  if (summary == null) return false;
  final start = DateTime.now();
  final dayStart = DateTime(start.year, start.month, start.day);
  for (final t in summary.transactions) {
    if (t.type == 'DAILY_CHECKIN' && !t.createdAt.isBefore(dayStart)) {
      return false;
    }
  }
  return true;
});

class LoyaltyController extends AsyncNotifier<LoyaltySummary> {
  LoyaltyRepository get _repo => ref.read(loyaltyRepositoryProvider);

  @override
  Future<LoyaltySummary> build() => _repo.fetchSummary();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.fetchSummary());
  }

  Future<LoyaltyEarnResult> earnParking(double kwd, {String? reference}) async {
    final earn = await _repo.earnParkingSession(kwd, reference: reference);
    await refresh();
    return earn;
  }

  Future<LoyaltyEarnResult> dailyCheckIn() async {
    final earn = await _repo.dailyCheckIn();
    await refresh();
    return earn;
  }

  Future<LoyaltyEarnResult> earnReview({String? reference}) async {
    final earn = await _repo.earnReview(reference: reference);
    await refresh();
    return earn;
  }

  Future<double> redeemHundred() async {
    await _repo.redeem(100);
    ref.invalidate(walletSummaryProvider);
    await refresh();
    return 5.0;
  }
}

/// Human-readable API / mock errors for SnackBars.
String loyaltyErrorMessage(Object error) {
  if (error is DioException) {
    final code = error.response?.data;
    if (code is Map && code['message'] is String) return code['message'] as String;
    if (error.response?.statusCode == 409) return 'already_checked_in_today';
    return error.message ?? 'Network error';
  }
  final s = error.toString();
  if (s.contains('already_checked_in_today')) return 'already_checked_in_today';
  if (s.contains('insufficient_balance')) return 'insufficient_balance';
  return s;
}
