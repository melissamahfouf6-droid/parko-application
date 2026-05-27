import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

enum ParkoMapDisplayType { normal, satellite }

class MapLayerSettings {
  const MapLayerSettings({
    this.showSharedSpots = true,
    this.showPrivateSpots = true,
    this.displayType = ParkoMapDisplayType.normal,
  });

  final bool showSharedSpots;
  final bool showPrivateSpots;
  final ParkoMapDisplayType displayType;

  gmaps.MapType get googleMapType =>
      displayType == ParkoMapDisplayType.satellite ? gmaps.MapType.satellite : gmaps.MapType.normal;

  MapLayerSettings copyWith({
    bool? showSharedSpots,
    bool? showPrivateSpots,
    ParkoMapDisplayType? displayType,
  }) {
    return MapLayerSettings(
      showSharedSpots: showSharedSpots ?? this.showSharedSpots,
      showPrivateSpots: showPrivateSpots ?? this.showPrivateSpots,
      displayType: displayType ?? this.displayType,
    );
  }

  static const defaults = MapLayerSettings();
}

final mapLayerSettingsProvider =
    StateProvider<MapLayerSettings>((ref) => MapLayerSettings.defaults);
