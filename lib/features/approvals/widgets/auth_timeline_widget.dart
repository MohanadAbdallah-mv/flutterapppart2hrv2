// lib/features/approvals/widgets/auth_timeline_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/app_colors.dart';

class AuthTimeline extends StatefulWidget {
  final List<dynamic> authItems;
  const AuthTimeline({super.key, required this.authItems});

  @override
  State<AuthTimeline> createState() => _AuthTimelineState();
}

class _AuthTimelineState extends State<AuthTimeline> {
  int _activeAuthStep = 0;

  @override
  void initState() {
    super.initState();
    // تحديد الخطوة النشطة، غالباً ما تكون آخر خطوة تمت
    if (widget.authItems.isNotEmpty) {
      _activeAuthStep = widget.authItems.length - 1;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'غير محدد';
    try {
      // تجربة تنسيق التاريخ القادم من الاعتمادات (غالباً ما يكون بهذا الشكل)
      final inputFormat = DateFormat("dd-MM-yyyy hh:mm a", "en_US");
      final dateTime = inputFormat.parse(dateString);
      return DateFormat('yyyy/MM/dd hh:mm a', 'ar_SA').format(dateTime);
    } catch (e) {
      // محاولة تنسيق آخر إذا فشل الأول
      try {
        final dateTime = DateTime.parse(dateString);
        return DateFormat('yyyy/MM/dd hh:mm a', 'ar_SA').format(dateTime);
      } catch (e2) {
        return dateString; // إرجاع النص الأصلي إذا فشلت كل المحاولات
      }
    }
  }

  String _getAuthStatusText(int? authFlag) {
    switch (authFlag) {
      case 1:
        return 'معتمد';
      case -1:
        return 'مرفوض';
      default:
        return 'قيد الإجراء';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.authItems.isEmpty) {
      return const Center(
          child: Text("لا توجد خطوات اعتماد.",
              style: TextStyle(color: AppColors.hintColor)));
    }

    return Column(
      children: List.generate(widget.authItems.length, (index) {
        final item = widget.authItems[index];
        final bool isActiveStep = (index == _activeAuthStep);
        bool isCompleted = item.authFlag == 1;
        bool isRejected = item.authFlag == -1;
        IconData stepIconData;
        Color stepColor;

        Color precedingLineColor = AppColors.hintColor.withOpacity(0.4);
        if (index > 0) {
          if (widget.authItems[index - 1].authFlag == 1)
            precedingLineColor = AppColors.successColor;
          else if (widget.authItems[index - 1].authFlag == -1)
            precedingLineColor = AppColors.errorColor;
        }

        Color succeedingLineColor = AppColors.hintColor.withOpacity(0.4);
        if (isCompleted) {
          stepIconData = Icons.check_circle_rounded;
          stepColor = AppColors.successColor;
          succeedingLineColor = AppColors.successColor;
        } else if (isRejected) {
          stepIconData = Icons.cancel_rounded;
          stepColor = AppColors.errorColor;
          succeedingLineColor = AppColors.errorColor;
        } else {
          stepIconData = Icons.pending_actions_rounded;
          stepColor = isActiveStep
              ? AppColors.primaryColor
              : AppColors.hintColor.withOpacity(0.8);
        }

        return InkWell(
          onTap: () {
            if (mounted) setState(() => _activeAuthStep = index);
          },
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    if (index > 0)
                      Expanded(
                          child:
                          Container(width: 2.5, color: precedingLineColor)),
                    Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        child: Icon(stepIconData,
                            color: stepColor, size: isActiveStep ? 28 : 24)),
                    if (index < widget.authItems.length - 1)
                      Expanded(
                          child: Container(
                              width: 2.5, color: succeedingLineColor)),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: index < widget.authItems.length - 1 ? 10 : 0,
                        top: 5),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        color: isActiveStep
                            ? AppColors.primaryColor.withOpacity(0.05)
                            : Colors.grey.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: isActiveStep
                                ? AppColors.primaryColor.withOpacity(0.5)
                                : Colors.grey.withOpacity(0.3),
                            width: isActiveStep ? 1.0 : 0.7)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.usersName ?? 'غير معروف',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isActiveStep
                                    ? AppColors.primaryColor
                                    : AppColors.textColor)),
                        if (item.jobDesc != null && item.jobDesc!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(item.jobDesc!,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textColor.withOpacity(0.75))),
                        ],
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text('التاريخ: ${_formatDate(item.authDate)}',
                                style: TextStyle(
                                    fontSize: 11.5,
                                    color: AppColors.textColor
                                        .withOpacity(0.65))),
                            const Spacer(),
                            Text(_getAuthStatusText(item.authFlag),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: stepColor,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        if (item.usersDesc != null &&
                            item.usersDesc!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(
                                    top:
                                    BorderSide(color: Colors.grey.shade200))),
                            child: Text('الملاحظات: ${item.usersDesc}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color:
                                    AppColors.textColor.withOpacity(0.85),
                                    fontStyle: FontStyle.italic)),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}