import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLocales {
  static const supported = <Locale>[
    Locale('en'),
    Locale('ar'),
  ];
}

final appLocaleProvider = StateProvider<Locale>((ref) => const Locale('en'));

