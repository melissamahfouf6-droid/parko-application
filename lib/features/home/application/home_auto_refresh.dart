import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_refresh.dart';

/// Refreshes map-related data every 2 minutes while the home screen is mounted.
class HomeAutoRefresh extends ConsumerStatefulWidget {
  const HomeAutoRefresh({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<HomeAutoRefresh> createState() => _HomeAutoRefreshState();
}

class _HomeAutoRefreshState extends ConsumerState<HomeAutoRefresh> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 2), (_) {
      if (mounted) refreshHomeMapData(ref);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
