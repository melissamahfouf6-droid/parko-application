import '../domain/wallet_models.dart';
import 'wallet_repository.dart';

/// Single in-memory wallet for mock mode (loyalty redeem + wallet UI share balance).
final sharedMockWalletRepository = MockWalletRepository();

class MockWalletRepository implements WalletRepository {
  double _balance = 12.5;
  final List<WalletTransaction> _txs = [
    WalletTransaction(
      id: 'mock-tx-1',
      amountKwd: 12.5,
      type: 'SEED',
      reference: 'welcome_wallet',
      description: 'Welcome bonus',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Future<WalletSummary> getSummary() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return WalletSummary(
      balanceKwd: _balance,
      currency: 'KWD',
      paymentMethods: const ['knet', 'tap'],
      transactions: List.from(_txs),
    );
  }

  @override
  Future<WalletSummary> topUp(double amountKwd) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _balance = ((_balance + amountKwd) * 1000).round() / 1000;
    _txs.insert(
      0,
      WalletTransaction(
        id: 'mock-tx-${DateTime.now().millisecondsSinceEpoch}',
        amountKwd: amountKwd,
        type: 'TOP_UP',
        reference: 'topup_demo',
        description: 'Demo top-up (Tap/KNET)',
        createdAt: DateTime.now(),
      ),
    );
    return getSummary();
  }

  @override
  Future<WalletSummary> pay({
    required double amountKwd,
    required String reference,
    String? description,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (_balance < amountKwd) throw StateError('insufficient_balance');
    _balance = ((_balance - amountKwd) * 1000).round() / 1000;
    _txs.insert(
      0,
      WalletTransaction(
        id: 'mock-tx-${DateTime.now().millisecondsSinceEpoch}',
        amountKwd: -amountKwd,
        type: 'PAYMENT',
        reference: reference,
        description: description ?? 'Parking payment',
        createdAt: DateTime.now(),
      ),
    );
    return getSummary();
  }
}
