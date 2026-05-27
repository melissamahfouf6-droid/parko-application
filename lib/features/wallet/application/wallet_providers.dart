import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../../loyalty/application/loyalty_providers.dart';
import '../data/api_wallet_repository.dart';
import '../data/mock_wallet_repository.dart';
import '../data/wallet_repository.dart';
import '../domain/wallet_models.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final base = ApiConfig.parkoApiBase.trim();
  if (base.isEmpty) return sharedMockWalletRepository;
  return ApiWalletRepository(
    dio: ref.watch(dioProvider),
    baseUrl: base,
    userId: ref.watch(currentUserIdProvider),
  );
});

final walletSummaryProvider = FutureProvider<WalletSummary>((ref) {
  return ref.watch(walletRepositoryProvider).getSummary();
});

final walletBalanceProvider = Provider<AsyncValue<double>>((ref) {
  return ref.watch(walletSummaryProvider).whenData((s) => s.balanceKwd);
});

class WalletController {
  WalletController(this._ref);

  final Ref _ref;

  Future<WalletSummary> topUp(double amountKwd) async {
    final s = await _ref.read(walletRepositoryProvider).topUp(amountKwd);
    _ref.invalidate(walletSummaryProvider);
    return s;
  }

  Future<WalletSummary> payParking({
    required double amountKwd,
    required String lotId,
    required String lotName,
  }) async {
    final s = await _ref.read(walletRepositoryProvider).pay(
          amountKwd: amountKwd,
          reference: 'parking_$lotId',
          description: lotName,
        );
    _ref.invalidate(walletSummaryProvider);
    return s;
  }
}

final walletControllerProvider = Provider<WalletController>((ref) {
  return WalletController(ref);
});

String walletErrorMessage(Object e) {
  final msg = e.toString();
  if (msg.contains('insufficient_balance')) return 'insufficient_balance';
  return msg;
}
