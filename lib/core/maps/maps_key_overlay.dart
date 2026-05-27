import 'package:flutter/material.dart';

import '../theme/parko_colors.dart';
import 'maps_key_status.dart';

class MapsKeyOverlay extends StatelessWidget {
  const MapsKeyOverlay({super.key, required this.status});

  final MapsKeyStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == MapsKeyStatus.ok) return const SizedBox.shrink();

    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final platformSteps = isIos
        ? [
            '1. Google Cloud Console → enable Maps SDK for iOS + billing',
            '2. Create an API key (restrict to bundle id com.parko.kw.parko)',
            '3. Run: bash scripts/setup_google_maps_key.sh YOUR_KEY',
            '4. Stop the app, then: cd ios && pod install && flutter run',
          ]
        : [
            '1. Google Cloud Console → enable Maps SDK for Android + billing',
            '2. Add to android/local.properties:',
            '   GOOGLE_MAPS_API_KEY=your_key_here',
            '3. Or run: bash scripts/setup_google_maps_key.sh YOUR_KEY',
            '4. flutter run again',
          ];

    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0xFFE8EDF2),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 48),
                Icon(Icons.map_outlined, size: 56, color: ParkoColors.sky),
                const SizedBox(height: 16),
                Text(
                  'Google Maps needs an API key',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                Text(
                  status == MapsKeyStatus.unsupported
                      ? 'Live maps work on iOS, Android, and Web — not on macOS desktop.'
                      : 'Tiles stay blank until a valid key is installed for this platform.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.parko.textSecondary),
                ),
                const SizedBox(height: 20),
                if (status == MapsKeyStatus.missing)
                  ...platformSteps.map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(s, style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
