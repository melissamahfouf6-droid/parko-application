import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/maps/osm_tile_layers.dart';
import '../../../../core/theme/parko_colors.dart';
import '../../../marketplace/domain/private_spot_listing.dart';
import '../../../parking/domain/shared_spot_listing.dart';
import '../../domain/lot_map_cluster.dart';
import '../../domain/parking_lot.dart';
import 'map_marker_pin.dart';

/// OpenStreetMap — free, no Google Cloud billing or API key.
class OsmParkingMap extends StatefulWidget {
  const OsmParkingMap({
    super.key,
    required this.lots,
    required this.controller,
    required this.onTapLot,
    required this.markerColor,
    this.sharedSpots = const [],
    this.privateSpots = const [],
    this.onTapShared,
    this.onTapPrivate,
    this.onTapCluster,
    this.initialCenter,
    this.initialZoom = 12,
    this.tilesOfflineHint,
  });

  final List<ParkingLot> lots;
  final LatLng? initialCenter;
  final double initialZoom;
  final List<SharedSpotListing> sharedSpots;
  final List<PrivateSpotListing> privateSpots;
  final MapController controller;
  final ValueChanged<String> onTapLot;
  final ValueChanged<SharedSpotListing>? onTapShared;
  final ValueChanged<PrivateSpotListing>? onTapPrivate;
  final void Function(LatLng center, double zoom)? onTapCluster;
  final Color Function(ParkingLot lot) markerColor;
  final String? tilesOfflineHint;

  static const _kuwaitCenter = LatLng(29.3759, 47.9774);

  @override
  State<OsmParkingMap> createState() => _OsmParkingMapState();
}

class _OsmParkingMapState extends State<OsmParkingMap> {
  double _zoom = 12;

  void _onClusterTap(LotMapCluster cluster) {
    if (cluster.isSingle) {
      widget.onTapLot(cluster.representative.id);
      return;
    }
    final zoom = (_zoom + 2).clamp(12.0, 17.0);
    widget.controller.move(cluster.center, zoom);
    widget.onTapCluster?.call(cluster.center, zoom);
  }

  @override
  Widget build(BuildContext context) {
    final clusters = clusterParkingLots(widget.lots, _zoom);
    final showClusterCount = _zoom < 14;

    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: ParkoColors.sky.withOpacity(0.06),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ParkoColors.sky.withOpacity(0.12),
                context.parko.background,
              ],
            ),
          ),
          child: FlutterMap(
            mapController: widget.controller,
            options: MapOptions(
              initialCenter: widget.initialCenter ?? OsmParkingMap._kuwaitCenter,
              initialZoom: widget.initialZoom,
              interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
              onMapEvent: (event) {
                final z = widget.controller.camera.zoom;
                if ((z - _zoom).abs() > 0.15 && mounted) {
                  setState(() => _zoom = z);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: OsmTileLayers.primary,
                subdomains: OsmTileLayers.subdomains,
                userAgentPackageName: 'com.parko.kw.parko',
                maxZoom: 19,
                retinaMode: RetinaMode.isHighDensity(context),
              ),
              MarkerLayer(
                markers: clusters.map((cluster) {
                  if (cluster.isSingle) {
                    final lot = cluster.representative;
                    final color = widget.markerColor(lot);
                    return Marker(
                      point: cluster.center,
                      width: 44,
                      height: 52,
                      child: GestureDetector(
                        onTap: () => widget.onTapLot(lot.id),
                        child: MapLotCountPin(
                          color: color,
                          label: '${lot.availableSpots}',
                        ),
                      ),
                    );
                  }
                  final color = widget.markerColor(cluster.representative);
                  return Marker(
                    point: cluster.center,
                    width: 52,
                    height: 52,
                    child: GestureDetector(
                      onTap: () => _onClusterTap(cluster),
                      child: _ClusterPin(
                        count: cluster.lots.length,
                        color: color,
                        totalSpots: showClusterCount ? cluster.totalAvailable : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (widget.sharedSpots.isNotEmpty)
                MarkerLayer(
                  markers: widget.sharedSpots.where((s) => s.status == 'active').map((s) {
                    return Marker(
                      point: LatLng(s.lat, s.lng),
                      width: 44,
                      height: 52,
                      child: GestureDetector(
                        onTap: () => widget.onTapShared?.call(s),
                        child: const MapFlashPin(),
                      ),
                    );
                  }).toList(),
                ),
              if (widget.privateSpots.isNotEmpty)
                MarkerLayer(
                  markers: widget.privateSpots.map((p) {
                    return Marker(
                      point: LatLng(p.lat, p.lng),
                      width: 44,
                      height: 52,
                      child: GestureDetector(
                        onTap: () => widget.onTapPrivate?.call(p),
                        child: const MapGaragePin(),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
        if (widget.tilesOfflineHint != null)
          Positioned(
            left: 12,
            right: 12,
            top: 12,
            child: Material(
              color: ParkoColors.amber.withOpacity(0.95),
              borderRadius: BorderRadius.circular(10),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.wifi_off_rounded, size: 18, color: context.parko.textPrimary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.tilesOfflineHint!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Positioned(
          left: 12,
          bottom: 12,
          child: Material(
            color: context.parko.panel.withOpacity(0.92),
            borderRadius: BorderRadius.circular(8),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                _zoom < 14 ? '© CARTO · clustered' : '© CARTO / OSM',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.parko.textSecondary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ClusterPin extends StatelessWidget {
  const _ClusterPin({
    required this.count,
    required this.color,
    this.totalSpots,
  });

  final int count;
  final Color color;
  final int? totalSpots;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(blurRadius: 8, color: Colors.black26, offset: Offset(0, 2)),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        totalSpots != null ? '$count\n$totalSpots' : '$count',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 11,
          height: 1.1,
        ),
      ),
    );
  }
}
