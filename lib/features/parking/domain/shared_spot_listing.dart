class SharedSpotListing {
  const SharedSpotListing({
    required this.id,
    required this.lotId,
    required this.lotName,
    required this.lat,
    required this.lng,
    required this.remainingMinutes,
    required this.originalPriceKwd,
    required this.salePriceKwd,
    required this.discountPercent,
    this.sellerUserId,
    this.status = 'active',
  });

  final String id;
  final String? sellerUserId;
  final String lotId;
  final String lotName;
  final double lat;
  final double lng;
  final int remainingMinutes;
  final double originalPriceKwd;
  final double salePriceKwd;
  final int discountPercent;
  final String status;

  factory SharedSpotListing.fromJson(Map<String, dynamic> j) {
    return SharedSpotListing(
      id: j['id'] as String? ?? '',
      sellerUserId: j['sellerUserId'] as String?,
      lotId: j['lotId'] as String? ?? '',
      lotName: j['lotName'] as String? ?? '',
      lat: (j['lat'] as num?)?.toDouble() ?? 0,
      lng: (j['lng'] as num?)?.toDouble() ?? 0,
      remainingMinutes: (j['remainingMinutes'] as num?)?.toInt() ?? 0,
      originalPriceKwd: (j['originalPriceKwd'] as num?)?.toDouble() ?? 0,
      salePriceKwd: (j['salePriceKwd'] as num?)?.toDouble() ?? 0,
      discountPercent: (j['discountPercent'] as num?)?.toInt() ?? 20,
      status: j['status'] as String? ?? 'active',
    );
  }
}

class LeaveEarlyResult {
  const LeaveEarlyResult({
    required this.listing,
    required this.sellerRefundKwd,
    required this.handoffMinutes,
  });

  final SharedSpotListing listing;
  final double sellerRefundKwd;
  final int handoffMinutes;

  factory LeaveEarlyResult.fromJson(Map<String, dynamic> j) {
    return LeaveEarlyResult(
      listing: SharedSpotListing.fromJson(
        Map<String, dynamic>.from(j['listing'] as Map? ?? {}),
      ),
      sellerRefundKwd: (j['sellerRefundKwd'] as num?)?.toDouble() ?? 0,
      handoffMinutes: (j['handoffMinutes'] as num?)?.toInt() ?? 10,
    );
  }
}
