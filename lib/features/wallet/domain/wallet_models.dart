class WalletTransaction {
  const WalletTransaction({
    required this.id,
    required this.amountKwd,
    required this.type,
    required this.createdAt,
    this.reference,
    this.description,
  });

  final String id;
  final double amountKwd;
  final String type;
  final String? reference;
  final String? description;
  final DateTime createdAt;

  bool get isCredit => amountKwd > 0;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'] as String,
      amountKwd: (json['amountKwd'] as num).toDouble(),
      type: json['type'] as String,
      reference: json['reference'] as String?,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class WalletSummary {
  const WalletSummary({
    required this.balanceKwd,
    required this.currency,
    required this.transactions,
    this.paymentMethods = const [],
  });

  final double balanceKwd;
  final String currency;
  final List<String> paymentMethods;
  final List<WalletTransaction> transactions;

  factory WalletSummary.fromJson(Map<String, dynamic> json) {
    return WalletSummary(
      balanceKwd: (json['balanceKwd'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'KWD',
      paymentMethods: (json['paymentMethods'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      transactions: (json['transactions'] as List<dynamic>? ?? [])
          .map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
