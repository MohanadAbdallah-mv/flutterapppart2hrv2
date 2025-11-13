import 'package:flutter/material.dart';

class HomeMenuItemData {
  final String title;
  final IconData icon;
  final Color color; // لون الخلفية الخاص بهذا العنصر
  final VoidCallback onTap; // الإجراء عند النقر
  final int? notificationCount; // عدد الإشعارات (اختياري)

  HomeMenuItemData({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.notificationCount,
  });
}