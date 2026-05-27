class ParkingReservation {
  const ParkingReservation({
    required this.id,
    required this.lotId,
    required this.lotName,
    required this.startAt,
    required this.endAt,
    required this.priceKwd,
    required this.status,
    this.lat,
    this.lng,
    this.zoneLabel,
    this.walletPaid = false,
  });

  final String id;
  final String lotId;
  final String lotName;
  final DateTime startAt;
  final DateTime endAt;
  final double priceKwd;
  final String status;
  final double? lat;
  final double? lng;
  final String? zoneLabel;
  final bool walletPaid;

  bool get isUpcoming =>
      status == 'confirmed' && endAt.isAfter(DateTime.now());

  bool get eligibleForWalletRefund =>
      walletPaid && priceKwd > 0 && DateTime.now().isBefore(startAt);

  Duration get duration => endAt.difference(startAt);

  factory ParkingReservation.fromJson(Map<String, dynamic> json) {
    return ParkingReservation(
      id: json['id'] as String,
      lotId: json['lotId'] as String,
      lotName: json['lotName'] as String,
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      priceKwd: (json['priceKwd'] as num).toDouble(),
      status: json['status'] as String? ?? 'confirmed',
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      zoneLabel: json['zoneLabel'] as String?,
      walletPaid: json['walletPaid'] as bool? ?? false,
    );
  }
}

class ReservationsBundle {
  const ReservationsBundle({required this.upcoming, required this.history});

  final List<ParkingReservation> upcoming;
  final List<ParkingReservation> history;
}
