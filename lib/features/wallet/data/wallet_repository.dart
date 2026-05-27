import '../domain/wallet_models.dart';

abstract class WalletRepository {
  Future<WalletSummary> getSummary();

  Future<WalletSummary> topUp(double amountKwd);

  Future<WalletSummary> pay({
    required double amountKwd,
    required String reference,
    String? description,
  });
}
