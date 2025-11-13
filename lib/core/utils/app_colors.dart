
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF4F46E5); // لون بنفسجي مقترح
  static const Color accentColor = Color(0xFF4F46E5);
  static const Color backgroundColor = Colors.white;
  static const Color textFieldFillColor = Color(0xFFF5F5F5);
  static const Color textColor = Colors.black87;
  static const Color hintColor = Colors.grey;
  static const Color errorColor = Colors.redAccent;
  static const Color successColor = Colors.green;
  static Color getStatusColor(int? flag) {
    switch (flag) {
      case 1: return successColor;
      case -1: return errorColor;
      case 0: return Colors.orange.shade700; // تحت الإجراء
      default: return hintColor;
    }
  }
}

/*

ومحتاج منك لم تيجي تبعتلي تقولي بردك الكود كامل لصفحة الي فيها تعديلات وبدون اخطاء ارجوك

وممكن تعديل كمان في نفس الصفحة عاوز جزء المعلومات الي تحت يتناسب مع العربي لانك عاملة كان الكلام انجليزي من الشمال لليمين .

خلي بالك بردك عاوزك في كل صفحات التطبيق تنسق موضوع العربي لاني بلاحظ ان كل التطبيق بيحوي نظام من الشمال الي اليمين وبالاخص في ال slide show . وعاوز منك اختلاف الالوان وشكل محترف في كل slide show ونخلي الالوان من درجات اللون (0xFF4F46E5) انا عارف انك كنت عاملة بنفسجي بس انا غيرته وخليته اللون الازرق الي بعته ... فانا عاوز من في slide show تنوع بين اللون ده ودرجاته ومعاهم اللون الاخضر ممكن بردك .

واعطيني اكواد كاملة . من فضلك

 */


