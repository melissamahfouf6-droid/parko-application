class PrivateSpotListing {
  const PrivateSpotListing({
    required this.id,
    required this.title,
    required this.lat,
    required this.lng,
    required this.priceKwdPerDay,
    required this.availability,
    required this.rating,
    required this.reviewCount,
    this.estimatedMonthlyKwd,
  });

  final String id;
  final String title;
  final double lat;
  final double lng;
  final double priceKwdPerDay;
  final String availability;
  final double rating;
  final int reviewCount;
  final double? estimatedMonthlyKwd;

  factory PrivateSpotListing.fromJson(Map<String, dynamic> j) {
    return PrivateSpotListing(
      id: j['id'] as String? ?? '',
      title: j['title'] as String? ?? '',
      lat: (j['lat'] as num?)?.toDouble() ?? 0,
      lng: (j['lng'] as num?)?.toDouble() ?? 0,
      priceKwdPerDay: (j['priceKwdPerDay'] as num?)?.toDouble() ?? 0,
      availability: j['availability'] as String? ?? '',
      rating: (j['rating'] as num?)?.toDouble() ?? 4.5,
      reviewCount: (j['reviewCount'] as num?)?.toInt() ?? 0,
      estimatedMonthlyKwd: (j['estimatedMonthlyKwd'] as num?)?.toDouble(),
    );
  }
}
