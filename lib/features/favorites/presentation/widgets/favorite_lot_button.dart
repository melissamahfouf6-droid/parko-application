import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/parko_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/domain/parking_lot.dart';
import '../../application/favorites_providers.dart';

class FavoriteLotButton extends ConsumerStatefulWidget {
  const FavoriteLotButton({super.key, required this.lot});

  final ParkingLot lot;

  @override
  ConsumerState<FavoriteLotButton> createState() => _FavoriteLotButtonState();
}

class _FavoriteLotButtonState extends ConsumerState<FavoriteLotButton> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final saved = ref.watch(isLotSavedProvider(widget.lot.id));

    return IconButton(
      onPressed: _busy
          ? null
          : () async {
              setState(() => _busy = true);
              try {
                final nowSaved = await ref.read(favoritesControllerProvider).toggle(
                      lotId: widget.lot.id,
                      lotName: widget.lot.name,
                      lat: widget.lot.lat,
                      lng: widget.lot.lng,
                      currentlySaved: saved,
                    );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(nowSaved ? l10n.favoritesAdded : l10n.favoritesRemoved),
                  ),
                );
              } finally {
                if (mounted) setState(() => _busy = false);
              }
            },
      icon: _busy
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              saved ? Icons.star_rounded : Icons.star_outline_rounded,
              color: saved ? ParkoColors.amber : ParkoColors.gray,
            ),
    );
  }
}
