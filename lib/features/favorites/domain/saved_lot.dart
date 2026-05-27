class SavedLot {
  const SavedLot({
    required this.id,
    required this.lotId,
    required this.lotName,
    required this.lat,
    required this.lng,
    required this.savedAt,
  });

  final String id;
  final String lotId;
  final String lotName;
  final double lat;
  final double lng;
  final DateTime savedAt;

  factory SavedLot.fromJson(Map<String, dynamic> json) {
    return SavedLot(
      id: json['id'] as String? ?? json['lotId'] as String,
      lotId: json['lotId'] as String,
      lotName: json['lotName'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      savedAt: DateTime.parse(json['savedAt'] as String),
    );
  }
}
