import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../features/home/domain/parking_lot.dart';
import '../../l10n/app_localizations.dart';

Future<void> shareParkingLot(BuildContext context, ParkingLot lot) async {
  final l10n = AppLocalizations.of(context);
  final spots = '${lot.availableSpots}/${lot.totalSpots}';
  final price = lot.priceKwdPerHour == 0
      ? l10n.filterQuickFree
      : '${lot.priceKwdPerHour.toStringAsFixed(1)} KWD/hr';
  final text = l10n.shareLotMessage(
    lot.name,
    spots,
    price,
    lot.lat,
    lot.lng,
  );
  await Share.share(text, subject: lot.name);
}
