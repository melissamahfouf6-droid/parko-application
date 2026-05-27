import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/maps/osm_tile_layers.dart';
import '../../../core/network/dio_client.dart';

/// Probes whether raster map tiles are reachable (DNS / network).
final mapTilesReachableProvider = FutureProvider<bool>((ref) async {
  try {
    await ref.read(dioProvider).head<void>(
          OsmTileLayers.primary
              .replaceAll('{s}', 'a')
              .replaceAll('{z}', '12')
              .replaceAll('{x}', '2500')
              .replaceAll('{y}', '1700'),
          options: Options(
            receiveTimeout: const Duration(seconds: 4),
            sendTimeout: const Duration(seconds: 4),
            validateStatus: (s) => s != null && s < 500,
          ),
        );
    return true;
  } catch (_) {
    return false;
  }
});
