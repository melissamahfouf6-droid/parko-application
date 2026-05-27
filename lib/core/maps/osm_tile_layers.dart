/// OSM-compatible raster tile templates (Carto CDN is often more reachable than tile.openstreetmap.org).
class OsmTileLayers {
  OsmTileLayers._();

  static const primary = 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png';

  static const fallback = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  static const subdomains = ['a', 'b', 'c', 'd'];
}
