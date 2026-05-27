class ParkingHistoryItem {
  const ParkingHistoryItem({
    required this.id,
    required this.lotName,
    required this.paidKwd,
    required this.durationLabel,
    required this.startedAt,
    this.source = 'session',
    this.lotId,
  });

  final String id;
  final String? lotId;
  final String lotName;
  final double paidKwd;
  final String durationLabel;
  final DateTime startedAt;
  final String source;

  factory ParkingHistoryItem.fromSessionJson(Map<String, dynamic> json) {
    return ParkingHistoryItem(
      id: json['id'] as String,
      lotId: json['lotId'] as String?,
      lotName: json['lotName'] as String,
      paidKwd: (json['paidKwd'] as num).toDouble(),
      durationLabel: json['durationLabel'] as String? ?? '',
      startedAt: DateTime.parse(json['startedAt'] as String),
      source: 'session',
    );
  }

  factory ParkingHistoryItem.fromReservation({
    required String id,
    required String lotId,
    required String lotName,
    required double priceKwd,
    required DateTime startAt,
    required DateTime endAt,
  }) {
    final mins = endAt.difference(startAt).inMinutes;
    final h = mins ~/ 60;
    final m = mins % 60;
    return ParkingHistoryItem(
      id: id,
      lotId: lotId,
      lotName: lotName,
      paidKwd: priceKwd,
      durationLabel: h > 0 ? '${h}h ${m}m' : '${m}m',
      startedAt: startAt,
      source: 'reservation',
    );
  }
}
