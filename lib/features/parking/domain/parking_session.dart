class ParkingSession {
  const ParkingSession({
    required this.id,
    required this.lotId,
    required this.lotName,
    required this.lat,
    required this.lng,
    required this.durationMinutes,
    required this.paidKwd,
    required this.startedAt,
  });

  final String id;
  final String lotId;
  final String lotName;
  final double lat;
  final double lng;
  /// Total session length from [startedAt].
  final int durationMinutes;
  final double paidKwd;
  final DateTime startedAt;

  int get remainingMinutes {
    final end = startedAt.add(Duration(minutes: durationMinutes));
    final left = end.difference(DateTime.now()).inMinutes;
    return left.clamp(0, durationMinutes);
  }

  bool get isExpired => remainingMinutes <= 0;
}
