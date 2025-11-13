// lib/core/providers/locale_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  // ---== التعديل الأول: تحديد لغة افتراضية وعدم السماح بـ null ==---
  Locale _locale = const Locale('ar');
  static const String _languageCodeKey = 'languageCode';

  // ---== التعديل الثاني: تعديل الـ getter ليرجع قيمة غير فارغة ==---
  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    // إذا لم يجد لغة محفوظة، سيستخدم اللغة الافتراضية 'ar'
    String languageCode = prefs.getString(_languageCodeKey) ?? 'ar';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale newLocale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, newLocale.languageCode);
    _locale = newLocale;
    notifyListeners();
  }

  void toggleLocale() {
    if (_locale.languageCode == 'ar') {
      setLocale(const Locale('en'));
    } else {
      setLocale(const Locale('ar'));
    }
  }
}



