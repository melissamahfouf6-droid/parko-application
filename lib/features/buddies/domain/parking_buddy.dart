class ParkingBuddy {
  const ParkingBuddy({
    required this.id,
    required this.displayName,
    required this.destination,
    required this.timeWindow,
    required this.seatsNeeded,
  });

  final String id;
  final String displayName;
  final String destination;
  final String timeWindow;
  final int seatsNeeded;

  factory ParkingBuddy.fromJson(Map<String, dynamic> j) {
    return ParkingBuddy(
      id: j['id'] as String? ?? '',
      displayName: j['displayName'] as String? ?? 'User',
      destination: j['destination'] as String? ?? '',
      timeWindow: j['timeWindow'] as String? ?? 'within_1h',
      seatsNeeded: (j['seatsNeeded'] as num?)?.toInt() ?? 1,
    );
  }
}
