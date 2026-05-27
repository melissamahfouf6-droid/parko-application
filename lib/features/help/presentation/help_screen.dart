import 'package:flutter/material.dart';

import '../../../core/theme/parko_colors.dart';
import '../../../l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = <({String q, String a})>[
      (q: l10n.helpFaq1Q, a: l10n.helpFaq1A),
      (q: l10n.helpFaq2Q, a: l10n.helpFaq2A),
      (q: l10n.helpFaq3Q, a: l10n.helpFaq3A),
      (q: l10n.helpFaq4Q, a: l10n.helpFaq4A),
      (q: l10n.helpFaq5Q, a: l10n.helpFaq5A),
      (q: l10n.helpFaq6Q, a: l10n.helpFaq6A),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
          color: context.parko.textPrimary,
        ),
        title: Text(l10n.helpTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.helpIntro,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.parko.textSecondary),
          ),
          const SizedBox(height: 16),
          ...items.map(
            (e) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                title: Text(e.q, style: Theme.of(context).textTheme.titleSmall),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(e.a, style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.mail_outline_rounded, color: ParkoColors.sky),
            title: Text(l10n.helpContactTitle),
            subtitle: Text(l10n.helpContactEmail),
          ),
        ],
      ),
    );
  }
}
