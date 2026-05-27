class HourlyFillPoint {
  const HourlyFillPoint({required this.hour, required this.fillRate});

  final int hour;
  final double fillRate;

  factory HourlyFillPoint.fromJson(Map<String, dynamic> j) {
    return HourlyFillPoint(
      hour: (j['hour'] as num?)?.toInt() ?? 0,
      fillRate: (j['fillRate'] as num?)?.toDouble() ?? 0.7,
    );
  }
}

class ParkingPrediction {
  const ParkingPrediction({
    required this.lotId,
    required this.lotName,
    required this.insight,
    required this.probabilityPercent,
    required this.minutesUntilLikely,
    required this.hourlyPattern,
    this.typicalOpenTime,
    this.isCurrentlyFull = true,
  });

  final String lotId;
  final String lotName;
  final String insight;
  final String? typicalOpenTime;
  final int probabilityPercent;
  final int minutesUntilLikely;
  final bool isCurrentlyFull;
  final List<HourlyFillPoint> hourlyPattern;

  factory ParkingPrediction.fromJson(Map<String, dynamic> j) {
    return ParkingPrediction(
      lotId: j['lotId'] as String? ?? '',
      lotName: j['lotName'] as String? ?? '',
      insight: j['insight'] as String? ?? '',
      typicalOpenTime: j['typicalOpenTime'] as String?,
      probabilityPercent: (j['probabilityPercent'] as num?)?.toInt() ?? 0,
      minutesUntilLikely: (j['minutesUntilLikely'] as num?)?.toInt() ?? 0,
      isCurrentlyFull: j['isCurrentlyFull'] as bool? ?? true,
      hourlyPattern: (j['hourlyPattern'] as List<dynamic>? ?? [])
          .map((e) => HourlyFillPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
