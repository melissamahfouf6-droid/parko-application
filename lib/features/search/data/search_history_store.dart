import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/preferences_bootstrap.dart';

const _kRecentSearches = 'search_recent_destinations';
const _maxItems = 8;

class SearchHistoryStore {
  List<String> load() {
    final raw = PreferencesBootstrap.instance.getString(_kRecentSearches);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> add(String title) async {
    final t = title.trim();
    if (t.isEmpty) return;
    final current = load()..remove(t);
    current.insert(0, t);
    final trimmed = current.take(_maxItems).toList();
    await PreferencesBootstrap.instance.setString(
      _kRecentSearches,
      jsonEncode(trimmed),
    );
  }

  Future<void> clear() async {
    await PreferencesBootstrap.instance.remove(_kRecentSearches);
  }
}

final searchHistoryStoreProvider = Provider<SearchHistoryStore>((ref) => SearchHistoryStore());
