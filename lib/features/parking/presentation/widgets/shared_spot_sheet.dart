import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/parko_colors.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/parking_session_providers.dart';
import '../../domain/shared_spot_listing.dart';

class SharedSpotSheet extends ConsumerWidget {
  const SharedSpotSheet({super.key, required this.listing});

  final SharedSpotListing listing;

  static Future<void> show(BuildContext context, SharedSpotListing listing) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SharedSpotSheet(listing: listing),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: context.parko.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.flash_on_rounded, color: ParkoColors.amber, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  listing.lotName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.shareRemaining(listing.remainingMinutes, listing.discountPercent),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.parko.textSecondary),
          ),
          const SizedBox(height: 16),
          GradientButton(
            label: l10n.shareBuyNow(listing.salePriceKwd.toStringAsFixed(2)),
            onPressed: () async {
              try {
                await ref.read(shareParkingControllerProvider).claim(listing.id);
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.shareClaimSuccess)));
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
              }
            },
          ),
        ],
      ),
    );
  }
}
