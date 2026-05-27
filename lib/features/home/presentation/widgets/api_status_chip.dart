import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_health.dart';
import '../../../../core/theme/parko_colors.dart';
import '../../../../l10n/app_localizations.dart';

class ApiStatusChip extends ConsumerWidget {
  const ApiStatusChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(apiHealthProvider);

    return async.when(
      loading: () => const SizedBox(
        width: 10,
        height: 10,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => _Dot(label: l10n.apiStatusOffline, color: ParkoColors.red),
      data: (h) {
        switch (h.status) {
          case ApiConnectionStatus.live:
            return _Dot(label: l10n.apiStatusLive, color: ParkoColors.green);
          case ApiConnectionStatus.demo:
            return _Dot(label: l10n.apiStatusDemo, color: ParkoColors.amber);
          case ApiConnectionStatus.offline:
            return _Dot(label: l10n.apiStatusOffline, color: ParkoColors.red);
        }
      },
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
