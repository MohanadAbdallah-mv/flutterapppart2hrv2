// lib/features/shared_widgets/language_switcher_button.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/locale_provider.dart';

class LanguageSwitcherButton extends StatelessWidget {
  const LanguageSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, provider, child) {
        final isArabic = provider.locale.languageCode == 'ar';
        // تم تعديل النص ليصبح أكثر وضوحاً كما في الصورة
        final String buttonText = isArabic ? 'English' : 'العربية';

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              provider.toggleLocale();
            },
            borderRadius: BorderRadius.circular(25), // زيادة دائرية الحواف
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // تعديل الحشو
              decoration: BoxDecoration(
                // استخدام لون مختلف قليلاً ليتناسب مع التصميم
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.5), width: 1), // إضافة حدود
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.language,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}