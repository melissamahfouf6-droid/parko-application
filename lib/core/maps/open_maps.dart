import 'package:url_launcher/url_launcher.dart';

/// Opens Apple/Google maps directions to [lat],[lng].
Future<bool> openMapsNavigation({
  required double lat,
  required double lng,
  String? label,
}) async {
  final name = Uri.encodeComponent(label ?? 'Parking');
  final apple = Uri.parse('http://maps.apple.com/?daddr=$lat,$lng&q=$name');
  final google = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');

  try {
    if (await launchUrl(apple, mode: LaunchMode.externalApplication)) return true;
  } catch (_) {}
  try {
    return await launchUrl(google, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}
