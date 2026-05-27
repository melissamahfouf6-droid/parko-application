import 'package:flutter/material.dart';

import '../../../../core/theme/parko_colors.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/private_spot_listing.dart';

class PrivateSpotSheet extends StatelessWidget {
  const PrivateSpotSheet({super.key, required this.listing});

  final PrivateSpotListing listing;

  static Future<void> show(BuildContext context, PrivateSpotListing listing) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => PrivateSpotSheet(listing: listing),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 20),
      decoration: BoxDecoration(
        color: context.parko.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(listing.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(
            '${listing.priceKwdPerDay.toStringAsFixed(2)} KWD/day • ${listing.availability}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 6),
          Text(
            '${listing.rating} ★ (${listing.reviewCount} reviews) • ${l10n.marketplaceVerified}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.parko.textSecondary),
          ),
          const SizedBox(height: 16),
          GradientButton(
            label: l10n.marketplaceBookSpot,
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.marketplaceBookSoon)));
            },
          ),
        ],
      ),
    );
  }
}
