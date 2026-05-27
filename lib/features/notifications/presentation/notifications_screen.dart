import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router.dart';
import '../../../core/theme/parko_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../application/notification_filter_providers.dart';
import '../application/notifications_providers.dart';
import '../domain/app_notification.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(notificationFeedProvider);
    final filter = ref.watch(notificationFilterProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
          color: context.parko.textPrimary,
        ),
        title: Text(l10n.notificationsTitle),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) async {
              if (v == 'read') {
                await ref.read(notificationsControllerProvider).markAllRead();
              } else if (v == 'clear') {
                await ref.read(notificationsControllerProvider).clearRead();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.notificationsClearedRead)),
                );
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(value: 'read', child: Text(l10n.notificationsMarkAllRead)),
              PopupMenuItem(value: 'clear', child: Text(l10n.notificationsClearRead)),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Row(
              children: [
                _FilterChip(
                  label: l10n.notificationsFilterAll,
                  selected: filter == NotificationInboxFilter.all,
                  onTap: () => ref.read(notificationFilterProvider.notifier).state = NotificationInboxFilter.all,
                ),
                _FilterChip(
                  label: l10n.notificationsFilterReserve,
                  selected: filter == NotificationInboxFilter.reservation,
                  onTap: () => ref.read(notificationFilterProvider.notifier).state = NotificationInboxFilter.reservation,
                ),
                _FilterChip(
                  label: l10n.notificationsFilterWallet,
                  selected: filter == NotificationInboxFilter.wallet,
                  onTap: () => ref.read(notificationFilterProvider.notifier).state = NotificationInboxFilter.wallet,
                ),
                _FilterChip(
                  label: l10n.notificationsFilterShare,
                  selected: filter == NotificationInboxFilter.share,
                  onTap: () => ref.read(notificationFilterProvider.notifier).state = NotificationInboxFilter.share,
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: ParkoColors.sky,
              onRefresh: () async {
                ref.invalidate(notificationFeedProvider);
                await ref.read(notificationFeedProvider.future);
              },
              child: async.when(
                loading: () => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 120),
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
                error: (e, _) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 120),
                    Center(child: Text('$e')),
                  ],
                ),
                data: (feed) {
                  final items = filterNotifications(feed.items, filter);
                  if (items.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
                        Center(child: Text(l10n.notificationsEmpty)),
                      ],
                    );
                  }
                  final locale = Localizations.localeOf(context).languageCode;
                  final fmt = DateFormat.MMMd(locale).add_Hm();
                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final n = items[i];
                      return Dismissible(
                        key: ValueKey(n.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: ParkoColors.red.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.delete_outline_rounded, color: ParkoColors.red),
                        ),
                        onDismissed: (_) => ref.read(notificationsControllerProvider).dismiss(n.id),
                        child: _NotificationTile(
                          notification: n,
                          timeLabel: fmt.format(n.createdAt),
                          onTap: () => _openNotification(context, ref, n),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openNotification(BuildContext context, WidgetRef ref, ParkoNotification n) {
    ref.read(notificationsControllerProvider).markRead(n.id);
    switch (n.category) {
      case 'reservation':
      case 'reminder':
        context.push(AppRoute.myParking.path);
        break;
      case 'parking':
        context.go(AppRoute.home.path);
        break;
      case 'wallet':
        context.push(AppRoute.wallet.path);
        break;
      case 'prediction':
        context.go(AppRoute.home.path);
        break;
      default:
        break;
    }
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: ParkoColors.sky.withOpacity(0.2),
        checkmarkColor: ParkoColors.sky,
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.timeLabel,
    required this.onTap,
  });

  final ParkoNotification notification;
  final String timeLabel;
  final VoidCallback onTap;

  IconData _iconFor(String category) {
    switch (category) {
      case 'reservation':
        return Icons.event_available_rounded;
      case 'prediction':
        return Icons.insights_rounded;
      case 'share':
        return Icons.flash_on_rounded;
      case 'wallet':
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _colorFor(String category) {
    switch (category) {
      case 'reservation':
        return ParkoColors.sky;
      case 'prediction':
        return ParkoColors.purple;
      case 'share':
        return ParkoColors.amber;
      case 'wallet':
        return ParkoColors.green;
      default:
        return ParkoColors.gray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _colorFor(notification.category);
    return Material(
      color: notification.read ? Colors.white : ParkoColors.sky.withOpacity(0.06),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.parko.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_iconFor(notification.category), color: c),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: notification.read ? FontWeight.w600 : FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(notification.body, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 6),
                    Text(timeLabel, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.parko.textSecondary)),
                  ],
                ),
              ),
              if (!notification.read)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: ParkoColors.sky, shape: BoxShape.circle),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
