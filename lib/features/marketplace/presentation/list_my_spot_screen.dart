import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/parko_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/private_spot_sheet.dart';
import '../application/marketplace_providers.dart';

class ListMySpotScreen extends ConsumerStatefulWidget {
  const ListMySpotScreen({super.key});

  @override
  ConsumerState<ListMySpotScreen> createState() => _ListMySpotScreenState();
}

class _ListMySpotScreenState extends ConsumerState<ListMySpotScreen> {
  final _title = TextEditingController(text: 'My driveway — Salmiya');
  final _price = TextEditingController(text: '1.5');
  String _availability = 'Weekdays 8AM–5PM';
  XFile? _photo;

  @override
  void dispose() {
    _title.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final listings = ref.watch(marketplaceListingsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.parko.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.marketplaceListTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.marketplaceListMySpot, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          TextField(
            controller: _title,
            decoration: InputDecoration(labelText: l10n.marketplaceSpotTitleHint),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _price,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.marketplacePriceHint),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _availability,
            decoration: InputDecoration(labelText: l10n.marketplaceAvailabilityHint),
            items: [
              'Weekdays 8AM–5PM',
              '24/7',
              'Sat–Thu 6AM–10PM',
            ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => _availability = v ?? _availability),
          ),
          const SizedBox(height: 12),
          if (_photo != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(_photo!.path),
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
          ],
          OutlinedButton.icon(
            onPressed: () async {
              final picker = ImagePicker();
              final file = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
              if (file == null || !mounted) return;
              setState(() => _photo = file);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.marketplacePhotoAdded)),
              );
            },
            icon: const Icon(Icons.photo_camera_rounded),
            label: Text(_photo == null ? l10n.marketplaceAddPhoto : l10n.marketplaceChangePhoto),
          ),
          const SizedBox(height: 20),
          GradientButton(
            label: l10n.marketplaceSubmit,
            onPressed: () async {
              final price = double.tryParse(_price.text.trim()) ?? 1.5;
              await ref.read(marketplaceRepositoryProvider).createListing(
                    title: _title.text.trim(),
                    priceKwdPerDay: price,
                    availability: _availability,
                  );
              ref.invalidate(marketplaceListingsProvider);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.marketplaceListed)));
            },
          ),
          const SizedBox(height: 28),
          Text(l10n.marketplaceBrowseTitle, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 10),
          listings.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('$e'),
            data: (list) => Column(
              children: list.map((s) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.garage_rounded, color: ParkoColors.green),
                    title: Text(s.title),
                    subtitle: Text('${s.priceKwdPerDay} KWD/day • ${s.availability}'),
                    trailing: Text('${s.rating} ★'),
                    onTap: () => PrivateSpotSheet.show(context, s),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
