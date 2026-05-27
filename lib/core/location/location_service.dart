import 'package:geolocator/geolocator.dart';

import 'map_center.dart';

class LocationService {
  Future<MapCenter?> getCurrentCenter() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
      timeLimit: const Duration(seconds: 12),
    );
    return MapCenter(lat: pos.latitude, lng: pos.longitude, label: 'near_me');
  }
}
