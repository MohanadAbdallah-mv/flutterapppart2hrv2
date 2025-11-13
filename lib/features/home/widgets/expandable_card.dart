import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';

class ExpandableMenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final bool isExpanded;
  final VoidCallback onExpansionChanged;
  final int? notificationCount; // لعرض عدد الإشعارات

  const ExpandableMenuCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    required this.isExpanded,
    required this.onExpansionChanged,
    this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isExpanded ? 4.0 : 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: AppColors.primaryColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: onExpansionChanged,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Icon(icon, color: AppColors.primaryColor, size: 28),
                      const SizedBox(width: 16),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (notificationCount != null && notificationCount! > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.errorColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            notificationCount.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: Container(), //  عندما يكون مطويًا
            secondChild: Container( // عندما يكون موسعًا
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top:0),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.03),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
            firstCurve: Curves.easeOut,
            secondCurve: Curves.easeIn,
            sizeCurve: Curves.bounceInOut, // تأثير حركة لطيف عند التوسيع
          ),
        ],
      ),
    );
  }
}

// Widget لعناصر القائمة داخل الكارت
class MenuListItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final int? notificationCount;

  const MenuListItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // تم تعديل الحشوة الداخلية
        child: Row(
          children: [
            Icon(icon, color: AppColors.accentColor, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, color: AppColors.textColor.withOpacity(0.9)),
              ),
            ),
            if (notificationCount != null && notificationCount! > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.errorColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  notificationCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.hintColor),
          ],
        ),
      ),
    );
  }
}