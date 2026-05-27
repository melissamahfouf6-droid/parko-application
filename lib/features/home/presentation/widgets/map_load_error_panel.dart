import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/api_config.dart';
import '../../../../core/theme/parko_colors.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_providers.dart';
import '../../application/home_refresh.dart';

class MapLoadErrorPanel extends ConsumerWidget {
  const MapLoadErrorPanel({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final message = error.toString();
    final isConnection = message.contains('Connection') ||
        message.contains('connection') ||
        message.contains('SocketException') ||
        message.contains('Failed host lookup');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 56, color: context.parko.textSecondary),
            const SizedBox(height: 16),
            Text(
              l10n.mapLoadErrorTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isConnection ? l10n.mapLoadErrorConnection : l10n.mapLoadErrorGeneric,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.parko.textSecondary),
            ),
            if (ApiConfig.parkoApiBase.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                l10n.mapLoadErrorApiHint(ApiConfig.parkoApiBase),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.parko.textSecondary),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: 220,
              child: GradientButton(
                label: l10n.mapRetry,
                icon: Icons.refresh_rounded,
                onPressed: () {
                  ref.invalidate(nearbyLotsProvider);
                  refreshHomeMapData(ref);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
