import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:latlong2/latlong.dart' as ll;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

import '../../../app/router.dart';
import '../../../core/maps/maps_key_status.dart';
import '../../../core/platform/apple_simulator.dart';
import '../../../core/theme/parko_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../application/home_providers.dart';
import '../application/home_auto_refresh.dart';
import '../application/home_refresh.dart';
import '../../loyalty/presentation/widgets/home_check_in_banner.dart';
import '../application/map_location_providers.dart';
import '../application/parking_filters.dart';
import '../../notifications/presentation/widgets/notification_bell_button.dart';
import '../domain/parking_lot.dart';
import '../../loyalty/presentation/widgets/loyalty_home_chip.dart';
import '../../wallet/presentation/widgets/wallet_home_chip.dart';
import '../../buddies/presentation/widgets/home_buddies_card.dart';
import '../../marketplace/application/marketplace_providers.dart';
import '../../marketplace/presentation/widgets/home_marketplace_cta.dart';
import '../../marketplace/presentation/widgets/private_spot_sheet.dart';
import '../../parking/application/parking_session_providers.dart';
import '../../parking/domain/shared_spot_listing.dart';
import '../../marketplace/domain/private_spot_listing.dart';
import '../../parking/presentation/widgets/leave_early_sheet.dart';
import '../../parking/presentation/widgets/shared_spot_sheet.dart';
import '../../parking/presentation/widgets/shared_spots_banner.dart';
import '../../predictions/presentation/widgets/prediction_home_banner.dart';
import '../../reservations/presentation/widgets/home_reservation_banner.dart';
import '../../parking/presentation/widgets/home_active_session_banner.dart';
import '../application/map_layers_providers.dart';
import '../application/map_tiles_providers.dart';
import '../domain/lot_map_cluster.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/map_layers_sheet.dart';
import 'widgets/home_drawer.dart';
import 'widgets/osm_parking_map.dart';
import 'widgets/map_legend.dart';
import 'widgets/map_load_error_panel.dart';
import 'widgets/map_quick_filter_chips.dart';
import 'widgets/api_status_chip.dart';
import 'widgets/home_favorites_strip.dart';
import 'widgets/parking_lot_sheet.dart';
import '../../../core/network/api_health.dart';
import '../../predictions/application/prediction_providers.dart';

/// `google_maps_flutter` only implements Android, iOS, and Web — not macOS/Linux/Windows.
bool get _googleMapEmbedAvailable {
  if (kIsWeb) return true;
  return defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
}

double _markerHue(ParkingLot lot) {
  if (lot.hasValet) return gmaps.BitmapDescriptor.hueViolet;
  final ratio = lot.availabilityRatio;
  if (ratio <= 0.1) return gmaps.BitmapDescriptor.hueRed;
  if (ratio <= 0.3) return gmaps.BitmapDescriptor.hueOrange;
  return gmaps.BitmapDescriptor.hueGreen;
}

Color _markerColor(ParkingLot lot) {
  if (lot.hasValet) return ParkoColors.purple;
  final ratio = lot.availabilityRatio;
  if (ratio <= 0.1) return ParkoColors.red;
  if (ratio <= 0.3) return ParkoColors.amber;
  return ParkoColors.green;
}

class HomeMapScreen extends ConsumerStatefulWidget {
  const HomeMapScreen({super.key});

  @override
  ConsumerState<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends ConsumerState<HomeMapScreen> {
  gmaps.GoogleMapController? _googleMap;
  final MapController _osmController = MapController();
  MapsKeyStatus _mapsKeyStatus = MapsKeyStatus.missing;

  bool get _useGoogleMaps =>
      _googleMapEmbedAvailable && _mapsKeyStatus == MapsKeyStatus.ok;

  @override
  void initState() {
    super.initState();
    if (_googleMapEmbedAvailable) {
      fetchMapsKeyStatus().then((s) {
        if (mounted) setState(() => _mapsKeyStatus = s);
      });
    }
  }

  void _panMapTo(double lat, double lng, {double zoom = 14}) {
    if (_useGoogleMaps) {
      _googleMap?.animateCamera(
        gmaps.CameraUpdate.newCameraPosition(
          gmaps.CameraPosition(target: gmaps.LatLng(lat, lng), zoom: zoom),
        ),
      );
    } else {
      _osmController.move(ll.LatLng(lat, lng), zoom);
    }
  }

  Future<void> _centerOnUser() async {
    final l10n = AppLocalizations.of(context);
    final ok = await ref.read(mapLocationControllerProvider).centerOnUser();
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.locationUnavailable)),
      );
      return;
    }
    final center = ref.read(mapCenterProvider);
    if (center != null) _panMapTo(center.lat, center.lng);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.locationFound)),
    );
  }

  Future<void> _focusLotById(String lotId) async {
    final lots = ref.read(nearbyLotsProvider).valueOrNull;
    if (lots == null) {
      await ref.read(nearbyLotsProvider.future);
    }
    final all = ref.read(nearbyLotsProvider).valueOrNull ?? [];
    ParkingLot? lot;
    for (final l in all) {
      if (l.id == lotId) {
        lot = l;
        break;
      }
    }
    if (lot == null || !mounted) {
      ref.read(mapFocusLotIdProvider.notifier).state = null;
      return;
    }
    ref.read(mapLocationControllerProvider).focusLot(lot);
    _panMapTo(lot.lat, lot.lng);
    _onLotTapped(context, lot.id);
    ref.read(mapFocusLotIdProvider.notifier).state = null;
  }

  Future<void> _applySearchResult(String picked) async {
    final l10n = AppLocalizations.of(context);
    final focusId = ref.read(mapFocusLotIdProvider);
    if (focusId != null) {
      await _focusLotById(focusId);
      return;
    }
    final center = ref.read(mapCenterProvider);
    if (center?.label == 'near_me' || picked == l10n.searchNearMe) {
      if (center != null) _panMapTo(center.lat, center.lng);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.locationFound)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.searchSelected(picked))),
    );
  }

  @override
  void dispose() {
    _googleMap?.dispose();
    _osmController.dispose();
    super.dispose();
  }

  void _zoomOsm(double delta) {
    final cam = _osmController.camera;
    _osmController.move(cam.center, (cam.zoom + delta).clamp(3, 18));
  }

  Future<void> _openSearch(BuildContext context) async {
    final picked = await context.push<String>(AppRoute.search.path);
    if (!context.mounted || picked == null) return;
    await _applySearchResult(picked);
  }

  void _onLotTapped(BuildContext context, String id) {
    ref.read(selectedParkingLotIdProvider.notifier).state = id;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ParkingLotSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(mapFocusLotIdProvider, (prev, next) {
      if (next != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _focusLotById(next));
      }
    });

    ref.watch(waitlistSyncProvider);
    ref.watch(apiHealthProvider);
    final tilesOk = ref.watch(mapTilesReachableProvider).valueOrNull ?? true;

    final l10n = AppLocalizations.of(context);
    final lotsAsync = ref.watch(filteredNearbyLotsProvider);
    final offlineFallback = ref.watch(mapOfflineFallbackProvider);
    final sharedAsync = ref.watch(sharedListingsProvider);
    final session = ref.watch(activeParkingSessionProvider);
    final listed = ref.watch(hasListedSpotProvider);
    final top = MediaQuery.of(context).padding.top + 12;
    final layers = ref.watch(mapLayerSettingsProvider);
    final allShared = sharedAsync.valueOrNull ?? const <SharedSpotListing>[];
    final sharedList = layers.showSharedSpots ? allShared : const <SharedSpotListing>[];
    final allPrivate = ref.watch(marketplaceListingsProvider).valueOrNull ?? const <PrivateSpotListing>[];
    final marketplaceList = layers.showPrivateSpots ? allPrivate : const <PrivateSpotListing>[];
    final mapCenter = ref.watch(mapCenterProvider) ?? kuwaitCityCenter;
    final busy = ref.watch(locationBusyProvider);

    return Scaffold(
      drawer: const HomeDrawer(),
      body: HomeAutoRefresh(
        child: Stack(
        children: [
          Positioned.fill(
            child: lotsAsync.when(
              data: (lots) {
                final mapLots = lots.isNotEmpty
                    ? lots
                    : (ref.read(nearbyLotsProvider).valueOrNull ?? lots);
                Widget map;
                if (_useGoogleMaps) {
                  map = _GoogleParkingMap(
                    lots: mapLots,
                    mapType: layers.googleMapType,
                    initialLat: mapCenter.lat,
                    initialLng: mapCenter.lng,
                    mapController: _googleMap,
                    onMapCreated: (c) => _googleMap = c,
                    onTapLot: (id) => _onLotTapped(context, id),
                  );
                } else {
                  map = OsmParkingMap(
                    lots: mapLots,
                    sharedSpots: sharedList,
                    privateSpots: marketplaceList,
                    controller: _osmController,
                    initialCenter: ll.LatLng(mapCenter.lat, mapCenter.lng),
                    tilesOfflineHint: tilesOk ? null : l10n.mapTilesOfflineHint,
                    onTapLot: (id) => _onLotTapped(context, id),
                    onTapShared: (s) => SharedSpotSheet.show(context, s),
                    onTapPrivate: (p) => PrivateSpotSheet.show(context, p),
                    markerColor: _markerColor,
                  );
                }
                return Stack(
                  children: [
                    map,
                    if (lots.isEmpty && mapLots.isNotEmpty)
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 100,
                        child: _MapFiltersEmptyHint(),
                      ),
                    if (offlineFallback)
                      Positioned(
                        left: 16,
                        right: 16,
                        top: top + 120,
                        child: _MapOfflineBanner(),
                      ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => MapLoadErrorPanel(error: e),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            top: top,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (ctx) => _RoundIconButton(
                    icon: Icons.menu_rounded,
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SearchBar(
                    hint: l10n.searchHint,
                    onTap: () => _openSearch(context),
                  ),
                ),
                const SizedBox(width: 8),
                const NotificationBellButton(),
                const SizedBox(width: 6),
                const WalletHomeChip(),
                const SizedBox(width: 6),
                const LoyaltyHomeChip(),
              ],
            ),
          ),
          Positioned(
            left: 72,
            right: 16,
            top: top + 50,
            child: const Align(
              alignment: Alignment.centerLeft,
              child: ApiStatusChip(),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            top: top + 72,
            child: const PredictionHomeBanner(),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: top + 72 + 96,
            child: const SharedSpotsBanner(),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: top + 72 + 96 + 52,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MapQuickFilterChips(),
                SizedBox(height: 6),
                HomeFavoritesStrip(),
                SizedBox(height: 6),
                HomeCheckInBanner(),
                SizedBox(height: 6),
                HomeActiveSessionBanner(),
                SizedBox(height: 6),
                HomeReservationBanner(),
                SizedBox(height: 6),
                HomeBuddiesCard(),
                SizedBox(height: 6),
                HomeMarketplaceCta(),
              ],
            ),
          ),
          Positioned(
            left: 16,
            bottom: session != null && !listed ? 88 : 26,
            child: const MapLegend(),
          ),
          if (session != null && !listed)
            Positioned(
              left: 16,
              bottom: 26,
              child: FloatingActionButton.extended(
                heroTag: 'share_spot',
                backgroundColor: ParkoColors.amber,
                foregroundColor: context.parko.textPrimary,
                onPressed: () => LeaveEarlySheet.show(context, session),
                icon: const Icon(Icons.flash_on_rounded),
                label: Text(l10n.shareSpotFab),
              ),
            ),

          Positioned(
            right: 16,
            top: top + 72 + 96 + 52 + 120,
            child: Column(
              children: [
                _RoundIconButton(
                  icon: Icons.refresh_rounded,
                  onPressed: () async {
                    refreshHomeMapData(ref);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.homeRefreshed)),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _RoundIconButton(
                  icon: Icons.tune_rounded,
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const FilterSheet(),
                  ),
                ),
                const SizedBox(height: 10),
                _RoundIconButton(
                  icon: Icons.layers_rounded,
                  onPressed: () => MapLayersSheet.show(context),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            bottom: 26,
            child: Column(
              children: [
                _RoundIconButton(
                  icon: Icons.add,
                  onPressed: () {
                    if (_useGoogleMaps) {
                      _googleMap?.animateCamera(gmaps.CameraUpdate.zoomIn());
                    } else {
                      _zoomOsm(1);
                    }
                  },
                ),
                const SizedBox(height: 10),
                _RoundIconButton(
                  icon: Icons.remove,
                  onPressed: () {
                    if (_useGoogleMaps) {
                      _googleMap?.animateCamera(gmaps.CameraUpdate.zoomOut());
                    } else {
                      _zoomOsm(-1);
                    }
                  },
                ),
                const SizedBox(height: 10),
                _RoundIconButton(
                  icon: busy ? Icons.hourglass_top_rounded : Icons.my_location_rounded,
                  onPressed: busy ? null : () => _centerOnUser(),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _GoogleParkingMap extends StatefulWidget {
  const _GoogleParkingMap({
    required this.lots,
    required this.mapType,
    required this.initialLat,
    required this.initialLng,
    required this.mapController,
    required this.onMapCreated,
    required this.onTapLot,
  });

  final List<ParkingLot> lots;
  final gmaps.MapType mapType;
  final double initialLat;
  final double initialLng;
  final gmaps.GoogleMapController? mapController;
  final ValueChanged<gmaps.GoogleMapController> onMapCreated;
  final ValueChanged<String> onTapLot;

  @override
  State<_GoogleParkingMap> createState() => _GoogleParkingMapState();
}

class _GoogleParkingMapState extends State<_GoogleParkingMap> {
  double _zoom = 12;

  void _onClusterTap(LotMapCluster cluster) {
    if (cluster.isSingle) {
      widget.onTapLot(cluster.representative.id);
      return;
    }
    final zoom = (_zoom + 2).clamp(12.0, 17.0);
    widget.mapController?.animateCamera(
      gmaps.CameraUpdate.newLatLngZoom(
        gmaps.LatLng(cluster.center.latitude, cluster.center.longitude),
        zoom,
      ),
    );
    setState(() => _zoom = zoom);
  }

  @override
  Widget build(BuildContext context) {
    final clusters = clusterParkingLots(widget.lots, _zoom);
    final markers = <gmaps.Marker>{};

    for (final cluster in clusters) {
      if (cluster.isSingle) {
        final lot = cluster.representative;
        final hue = _markerHue(lot);
        markers.add(
          gmaps.Marker(
            markerId: gmaps.MarkerId(lot.id),
            position: gmaps.LatLng(lot.lat, lot.lng),
            onTap: () => widget.onTapLot(lot.id),
            icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(hue),
            infoWindow: gmaps.InfoWindow(
              title: lot.name,
              snippet:
                  '${lot.availableSpots}/${lot.totalSpots} • ${lot.priceKwdPerHour.toStringAsFixed(1)} KWD/hr',
            ),
          ),
        );
      } else {
        final lot = cluster.representative;
        final hue = _markerHue(lot);
        markers.add(
          gmaps.Marker(
            markerId: gmaps.MarkerId(
              'cluster_${cluster.center.latitude}_${cluster.center.longitude}',
            ),
            position: gmaps.LatLng(cluster.center.latitude, cluster.center.longitude),
            onTap: () => _onClusterTap(cluster),
            icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(hue),
            infoWindow: gmaps.InfoWindow(
              title: '${cluster.lots.length} lots',
              snippet: '${cluster.totalAvailable} spots available',
            ),
          ),
        );
      }
    }

    return gmaps.GoogleMap(
      mapType: widget.mapType,
      initialCameraPosition: gmaps.CameraPosition(
        target: gmaps.LatLng(widget.initialLat, widget.initialLng),
        zoom: 12,
      ),
      myLocationEnabled: !runningOnAppleSimulator,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      markers: markers,
      onMapCreated: widget.onMapCreated,
      onCameraMove: (pos) {
        if ((pos.zoom - _zoom).abs() > 0.3) {
          setState(() => _zoom = pos.zoom);
        }
      },
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.hint, required this.onTap});
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.08),
      borderRadius: BorderRadius.circular(18),
      child: TextField(
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(Icons.search_rounded),
          filled: true,
          fillColor: context.parko.inputFill,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: context.parko.border),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: context.parko.border),
          ),
        ),
      ),
    );
  }
}

class _MapOfflineBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: ParkoColors.amber.withOpacity(0.92),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.cloud_off_rounded, size: 20, color: context.parko.textPrimary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.mapOfflineFallback,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapFiltersEmptyHint extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: context.parko.panel.withOpacity(0.95),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.mapNoLotsMatch, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () {
                ref.read(parkingMapFiltersProvider.notifier).state = ParkingMapFilters.defaults;
                ref.read(mapQuickFilterProvider.notifier).state = MapQuickFilter.all;
              },
              child: Text(l10n.resetFilters),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, this.onPressed});
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.parko.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.parko.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: context.parko.textPrimary),
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
      ),
    );
  }
}
