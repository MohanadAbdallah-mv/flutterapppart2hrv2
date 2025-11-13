// lib/features/auth/screens/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../home/screens/home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // عند بناء هذه الواجهة لأول مرة، نطلب من AuthProvider محاولة تسجيل الدخول التلقائي
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).tryAutoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // إذا لم تكتمل عملية التحقق بعد، نعرض شاشة تحميل
    if (!authProvider.isAuthChecked) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // بعد اكتمال التحقق، نقرر أي شاشة نعرضها
    if (authProvider.currentUser != null) {
      // إذا كان هناك مستخدم حالي، نعرض الشاشة الرئيسية
      return const HomeScreen();
    } else {
      // وإلا، نعرض شاشة تسجيل الدخول
      return const LoginScreen();
    }
  }
}