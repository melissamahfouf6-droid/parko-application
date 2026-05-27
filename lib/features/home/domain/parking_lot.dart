class ParkingLot {
  const ParkingLot({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.totalSpots,
    required this.availableSpots,
    required this.priceKwdPerHour,
    required this.rating,
    required this.reviewCount,
    required this.hasValet,
    this.supportsReservation = true,
    this.distanceKm,
    this.hoursLabel,
  });

  final String id;
  final String name;
  final double lat;
  final double lng;
  final int totalSpots;
  final int availableSpots;
  final double priceKwdPerHour;
  final double rating;
  final int reviewCount;
  final bool hasValet;
  final bool supportsReservation;
  final double? distanceKm;
  final String? hoursLabel;

  factory ParkingLot.fromJson(Map<String, dynamic> json) {
    return ParkingLot(
      id: json['id'] as String,
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      totalSpots: (json['totalSpots'] as num).toInt(),
      availableSpots: (json['availableSpots'] as num).toInt(),
      priceKwdPerHour: (json['priceKwdPerHour'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      hasValet: json['hasValet'] as bool? ?? false,
      supportsReservation: json['supportsReservation'] as bool? ?? true,
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      hoursLabel: json['hoursLabel'] as String?,
    );
  }

  double get availabilityRatio => totalSpots == 0 ? 0 : availableSpots / totalSpots;

  bool get isNearlyFull => availabilityRatio <= 0.1;

  bool get hasAvailabilityNow => availabilityRatio > 0.05;

  bool get isFree => priceKwdPerHour <= 0;
}

