import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';

import '../../../../core/theme/parko_colors.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/buddies_providers.dart';

class ParkingBuddiesSheet extends ConsumerWidget {
  const ParkingBuddiesSheet({super.key, required this.destination});

  final String destination;

  static Future<void> show(BuildContext context, String destination) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ParkingBuddiesSheet(destination: destination),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(buddiesForDestinationProvider(destination));

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      builder: (context, scroll) {
        return Container(
          decoration: BoxDecoration(
            color: context.parko.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: ListView(
            controller: scroll,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(color: context.parko.border, borderRadius: BorderRadius.circular(99)),
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.buddyFindTitle, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(destination, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ParkoColors.sky)),
              const SizedBox(height: 16),
              async.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('$e'),
                data: (buddies) {
                  if (buddies.isEmpty) {
                    return Text(l10n.buddyEmpty);
                  }
                  return Column(
                    children: [
                      ...buddies.map(
                        (b) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: ParkoColors.sky.withOpacity(0.2),
                              child: Text(b.displayName[0], style: const TextStyle(fontWeight: FontWeight.w800)),
                            ),
                            title: Text(b.displayName),
                            subtitle: Text(l10n.buddySeatsNeeded(b.seatsNeeded)),
                            trailing: IconButton(
                              icon: const Icon(Icons.chat_bubble_outline_rounded, color: ParkoColors.sky),
                              onPressed: () {
                                Navigator.of(context).pop();
                                context.push(
                                  '${AppRoute.buddyChat.path}?id=${Uri.encodeComponent(b.id)}&name=${Uri.encodeComponent(b.displayName)}',
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GradientButton(
                        label: l10n.buddyJoinSearch,
                        icon: Icons.group_add_rounded,
                        onPressed: () async {
                          await ref.read(buddiesRepositoryProvider).joinBuddySearch(destination);
                          ref.invalidate(buddiesForDestinationProvider(destination));
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.buddyJoined)));
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
