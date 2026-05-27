import '../domain/parking_prediction.dart';

/// Shared historical fill patterns (mirrors backend `predictions.service.ts`).
class PredictionEngine {
  PredictionEngine._();

  static const _lotNames = {
    'avenues': 'The Avenues Mall',
    'kuwait_uni': 'Kuwait University',
    'hospital': 'Dasman Diabetes Institute',
  };

  static const _patterns = <String, Map<int, Map<int, double>>>{
    'avenues': {
      4: {10: 0.92, 11: 0.9, 12: 0.85, 13: 0.78, 14: 0.55, 15: 0.42, 16: 0.48, 17: 0.62, 18: 0.75},
    },
    'kuwait_uni': {
      0: {8: 0.95, 9: 0.98, 10: 0.92, 11: 0.7, 12: 0.45},
      1: {8: 0.94, 9: 0.96, 10: 0.9, 11: 0.68, 12: 0.42},
      2: {8: 0.93, 9: 0.95, 10: 0.88, 11: 0.65, 12: 0.4},
      3: {8: 0.94, 9: 0.97, 10: 0.91, 11: 0.72, 12: 0.44},
      4: {8: 0.96, 9: 0.98, 10: 0.93, 11: 0.75, 12: 0.48},
    },
    'hospital': {
      0: {7: 0.88, 8: 0.82, 9: 0.75, 10: 0.65, 14: 0.55, 15: 0.48},
      1: {7: 0.87, 8: 0.8, 9: 0.74, 10: 0.63, 14: 0.52, 15: 0.45},
      2: {7: 0.86, 8: 0.79, 9: 0.72, 10: 0.6, 14: 0.5, 15: 0.42},
      3: {7: 0.88, 8: 0.81, 9: 0.76, 10: 0.64, 14: 0.54, 15: 0.47},
      4: {7: 0.9, 8: 0.84, 9: 0.78, 10: 0.68, 14: 0.58, 15: 0.5},
      5: {7: 0.85, 8: 0.78, 9: 0.7, 10: 0.58},
      6: {7: 0.82, 8: 0.75, 9: 0.68, 10: 0.55},
    },
  };

  static const _weekdays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  static ParkingPrediction forLot(String lotId, [DateTime? now]) {
    final n = now ?? DateTime.now();
    final name = _lotNames[lotId] ?? lotId;
    final dayIdx = n.weekday == 7 ? 0 : n.weekday;
    final hour = n.hour;
    final pattern = _patterns[lotId]?[dayIdx] ?? _patterns[lotId]?[4] ?? {};

    int? bestHour;
    var bestFill = 1.0;
    var minutesUntil = 20;

    for (var h = hour; h < 24; h++) {
      final fill = pattern[h] ?? _interpolate(pattern, h);
      if (fill < 0.35 && fill < bestFill) {
        bestHour = h;
        bestFill = fill;
        minutesUntil = (h - hour) * 60 - n.minute;
        if (minutesUntil < 0) minutesUntil = 15;
        break;
      }
    }

    if (bestHour == null) {
      for (var h = 0; h <= hour; h++) {
        final fill = pattern[h] ?? 0.5;
        if (fill < 0.35) {
          bestHour = h;
          bestFill = fill;
          minutesUntil = (24 - hour + h) * 60 - n.minute;
          break;
        }
      }
    }

    final typicalOpen = bestHour != null ? _formatTime(bestHour, 15) : null;
    final prob = _probability(bestFill, minutesUntil);
    final insight = typicalOpen != null
        ? '$name parking usually eases around $typicalOpen on ${_weekdays[dayIdx]}s'
        : '$name — limited historical relief today; try notify';

    final hourlyPattern = List.generate(12, (i) {
      final h = (hour + i) % 24;
      return HourlyFillPoint(hour: h, fillRate: pattern[h] ?? _interpolate(pattern, h));
    });

    return ParkingPrediction(
      lotId: lotId,
      lotName: name,
      insight: insight,
      typicalOpenTime: typicalOpen,
      probabilityPercent: prob,
      minutesUntilLikely: minutesUntil > 0 ? minutesUntil : 20,
      hourlyPattern: hourlyPattern,
    );
  }

  static List<ParkingPrediction> homeHighlights([DateTime? now]) {
    const ids = ['avenues', 'kuwait_uni', 'hospital'];
    final list = ids.map((id) => forLot(id, now)).where((p) => p.probabilityPercent >= 50).toList();
    list.sort((a, b) => a.minutesUntilLikely.compareTo(b.minutesUntilLikely));
    return list;
  }

  static double _interpolate(Map<int, double> pattern, int hour) {
    if (pattern.isEmpty) return 0.7;
    final keys = pattern.keys.toList()..sort();
    if (pattern.containsKey(hour)) return pattern[hour]!;
    int? before;
    int? after;
    for (final k in keys) {
      if (k < hour) before = k;
      if (k > hour && after == null) after = k;
    }
    if (before == null) return pattern[keys.first]!;
    if (after == null) return pattern[before]!;
    final t = (hour - before) / (after - before);
    return pattern[before]! * (1 - t) + pattern[after]! * t;
  }

  static int _probability(double fill, int minutesUntil) {
    var base = 72;
    if (fill < 0.45) base = 85;
    if (fill < 0.4) base = 88;
    if (minutesUntil <= 20) base = base + 5 > 92 ? 92 : base + 5;
    if (minutesUntil <= 45 && minutesUntil > 20) base = base + 3 > 90 ? 90 : base + 3;
    return base;
  }

  static String _formatTime(int hour, int minute) {
    final h12 = hour % 12 == 0 ? 12 : hour % 12;
    final ampm = hour < 12 ? 'AM' : 'PM';
    return '$h12:${minute.toString().padLeft(2, '0')} $ampm';
  }
}
