import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/parko_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/parking_review_providers.dart';
import '../../domain/parking_lot.dart';

class LotReviewSection extends ConsumerStatefulWidget {
  const LotReviewSection({super.key, required this.lot});

  final ParkingLot lot;

  @override
  ConsumerState<LotReviewSection> createState() => _LotReviewSectionState();
}

class _LotReviewSectionState extends ConsumerState<LotReviewSection> {
  int _stars = 5;
  final _comment = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _submitting = true);
    try {
      final result = await ref.read(parkingReviewControllerProvider).submit(
            lotId: widget.lot.id,
            stars: _stars,
            comment: _comment.text.trim().isEmpty ? null : _comment.text.trim(),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.reviewSubmitted(
              result.rating.toStringAsFixed(1),
              result.reviewCount,
              result.pointsAwarded,
            ),
          ),
        ),
      );
      _comment.clear();
    } catch (e) {
      if (!mounted) return;
      final msg = e is DioException &&
              e.response?.statusCode == 409
          ? l10n.reviewAlreadyToday
          : l10n.reviewFailed;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.reviewSectionTitle, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Text(
          l10n.reviewSectionHint,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.parko.textSecondary),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(5, (i) {
            final star = i + 1;
            return IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              onPressed: _submitting ? null : () => setState(() => _stars = star),
              icon: Icon(
                star <= _stars ? Icons.star_rounded : Icons.star_outline_rounded,
                color: ParkoColors.amber,
                size: 32,
              ),
            );
          }),
        ),
        TextField(
          controller: _comment,
          enabled: !_submitting,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: l10n.reviewCommentHint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            isDense: true,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _submitting ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: ParkoColors.sky,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: _submitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(l10n.reviewSubmit),
          ),
        ),
      ],
    );
  }
}
