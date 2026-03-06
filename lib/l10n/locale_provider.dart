// lib/l10n/locale_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── AppLocale (display data only — no more translation strings) ──────────────
class AppLocale {
  final String code;
  final String name;
  final String native;

  const AppLocale({
    required this.code,
    required this.name,
    required this.native,
  });

  static const en = AppLocale(code: 'en', name: 'English', native: 'English');
  static const hi = AppLocale(code: 'hi', name: 'Hindi',   native: 'हिन्दी');
  static const ta = AppLocale(code: 'ta', name: 'Tamil',   native: 'தமிழ்');

  static const all = [en, hi, ta];

  Locale toLocale() => Locale(code);

  static AppLocale fromLocale(Locale? l) =>
      all.firstWhere((a) => a.code == l?.languageCode, orElse: () => en);

  @override
  bool operator ==(Object other) => other is AppLocale && other.code == code;

  @override
  int get hashCode => code.hashCode;
}

// ── Simple ValueNotifier-based state ─────────────────────────────────────────


class LocaleNotifier extends ValueNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en'));

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('locale') ?? 'en';
    value = Locale(code);
  }

  Future<void> setLocale(AppLocale locale) async {
    value = locale.toLocale();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.code);
  }
}

// Single global instance — created once in main.dart
final localeNotifier = LocaleNotifier();