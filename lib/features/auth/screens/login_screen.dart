/*

import 'dart:ui'; // Required for ImageFilter.blur

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/locale_provider.dart'; // دعم تبديل اللغة
import '../../home/screens/home_screen.dart';
import '../../../core/utils/app_colors.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _userCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // تعريف الألوان الجديدة
  final Color _primaryColor = Color(0xFF4F46E5); // أزرق داكن للأزرار
  final Color _secondaryColor = Color(0xFFAAACD5); // اللون الرمادي المائل للأزرق

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.0, 0.5, curve: Curves.easeIn),
        )
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.3, 0.8, curve: Curves.easeOut),
        )
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _userCodeController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // دالة التحقق من رقم العميل
  String? validateUserCode(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.userCodeValidationError ?? 'يرجى إدخال رقم العميل';
    }
    return null;
  }

  // دالة التحقق من كلمة المرور
  String? validatePassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.passwordValidationError ?? 'يرجى إدخال كلمة المرور';
    }
    /*
    if (value.length < 2) {
      return l10n.passwordLengthError ?? 'كلمة المرور يجب أن تكون أطول';
    }*/
    return null;
  }

  Future<void> _performLogin() async {
    final l10n = AppLocalizations.of(context)!;

    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(
        _userCodeController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success && mounted) {
        _showStyledDialog(
          message: l10n.loginSuccessMessage ?? "تم تسجيل الدخول بنجاح",
          isSuccess: true,
          onContinue: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          },
        );
      } else if (mounted) {
        _showStyledDialog(
          message: authProvider.errorMessage ?? l10n.loginErrorMessage ?? "حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.",
          isSuccess: false,
          onContinue: () {
            Navigator.of(context).pop();
          },
        );
      }
    }
  }

  // دالة عرض الرسالة (النجاح أو الخطأ)
  void _showStyledDialog({
    required String message,
    required bool isSuccess,
    required VoidCallback onContinue,
  }) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: _secondaryColor.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSuccess ? Icons.check : Icons.error,
                        color: isSuccess ? _primaryColor : Colors.red,
                        size: 50,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      l10n.systemWelcomeMessage ?? "مرحباً بك في نظام إدارة موارد المؤسسة",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        l10n.continueButton ?? "متابعة",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ويدجت زر تبديل اللغة
  Widget _buildLanguageSwitcher() {
    return Consumer<LocaleProvider>(
      builder: (context, provider, child) {
        final isArabic = provider.locale?.languageCode == 'ar';
        return Container(
          child: TextButton(
            onPressed: () {
              provider.setLocale(Locale(isArabic ? 'en' : 'ar'));
            },
            style: TextButton.styleFrom(
              backgroundColor: _primaryColor.withOpacity(0.1),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language,
                  color: _primaryColor,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  isArabic ? 'English' : 'العربية',
                  style: TextStyle(
                    color: _primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            // أشكال زخرفية في الخلفية
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _secondaryColor.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              top: 150,
              left: -80,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _secondaryColor.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -20,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _secondaryColor.withOpacity(0.05),
                ),
              ),
            ),
            // محتوى الصفحة
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        padding: EdgeInsets.all(30),
                        width: size.width > 500 ? 500 : size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _secondaryColor.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // زر تبديل اللغة في أعلى الكارد
                              Align(
                                alignment: Alignment.topRight,
                                child: _buildLanguageSwitcher(),
                              ),
                              SizedBox(height: 10),
                              // شعار النظام
                              Container(
                                height: 110,
                                width: 110,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _primaryColor.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundImage: AssetImage("assets/images/ascon.jpg"),
                                ),
                              ),
                              SizedBox(height: 30),
                              // عنوان النظام
                              Text(
                                l10n.systemTitle ?? "نظام إدارة موارد المؤسسة",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black12,
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              // شريط فاصل مميز
                              Container(
                                width: 80,
                                height: 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: _secondaryColor,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                l10n.loginTitle,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 30),
                              // حقل رقم العميل
                              TextFormField(
                                controller: _userCodeController,
                                style: TextStyle(color: Colors.black87),
                                textDirection: TextDirection.ltr,
                                validator: (value) => validateUserCode(value, l10n),
                                decoration: InputDecoration(
                                  hintText: l10n.userCodeHint,
                                  hintStyle: TextStyle(color: Colors.black38),
                                  prefixIcon: Icon(Icons.supervised_user_circle_rounded, color: _secondaryColor),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: _secondaryColor.withOpacity(0.5)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: _primaryColor),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.red.shade300),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.red.shade300),
                                  ),
                                  errorStyle: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.05),
                                ),
                              ),
                              SizedBox(height: 20),
                              // حقل كلمة المرور
                              TextFormField(
                                controller: _passwordController,
                                style: TextStyle(color: Colors.black87),
                                obscureText: _obscurePassword,
                                textDirection: TextDirection.ltr,
                                validator: (value) => validatePassword(value, l10n),
                                decoration: InputDecoration(
                                  hintText: l10n.passwordHint,
                                  hintStyle: TextStyle(color: Colors.black38),
                                  prefixIcon: Icon(Icons.lock, color: _secondaryColor),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                      color: _secondaryColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: _secondaryColor.withOpacity(0.5)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: _primaryColor),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.red.shade300),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.red.shade300),
                                  ),
                                  errorStyle: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.05),
                                ),
                              ),
                              SizedBox(height: 15),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(_secondaryColor.withOpacity(0.1)),
                                  ),
                                  child: Text(
                                    l10n.forgotPassword ?? "نسيت كلمة المرور؟",
                                    style: TextStyle(
                                      color: _primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 25),
                              // زر تسجيل الدخول مع مؤشر التحميل
                              authProvider.isLoading
                                  ? Container(
                                width: 50,
                                height: 50,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _secondaryColor.withOpacity(0.2),
                                ),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                                  strokeWidth: 3,
                                ),
                              )
                                  : Container(
                                width: double.infinity,
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _primaryColor.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _performLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    l10n.login,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              // خيار التسجيل
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    l10n.noAccountText ?? "ليس لديك حساب؟",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  TextButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(_secondaryColor.withOpacity(0.1)),
                                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                                    ),
                                    child: Text(
                                      l10n.signUpText ?? "تسجيل جديد",
                                      style: TextStyle(
                                        color: _primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/



import 'dart:convert'; // لإستخدام json.decode
import 'dart:ui'; // Required for ImageFilter.blur
import 'package:http/http.dart' as http; // تأكد من وجود مكتبة http

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/locale_provider.dart'; // دعم تبديل اللغة
import '../../home/screens/home_screen.dart';
// import '../../../core/utils/app_colors.dart'; // (موجود عندك)

// --- 1. موديل بسيط للشركة (يمكنك فصله في ملف لاحقاً) ---
class CompanyModel {
  final int companyCode;
  final String companyDesc;
  final String companyDescE;

  CompanyModel({
    required this.companyCode,
    required this.companyDesc,
    required this.companyDescE,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      companyCode: json['CompanyCode'],
      companyDesc: json['CompanyDesc'] ?? '',
      companyDescE: json['CompanyDescE'] ?? '',
    );
  }
}
// -------------------------------------------------------

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _userCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // تعريف الألوان الجديدة
  final Color _primaryColor = Color(0xFF4F46E5); // أزرق داكن للأزرار
  final Color _secondaryColor = Color(0xFFAAACD5); // اللون الرمادي المائل للأزرق

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // --- متغيرات الشركات ---
  List<CompanyModel> _companies = [];
  CompanyModel? _selectedCompany;
  bool _isCompaniesLoading = false;
  String? _companyError;
  // ---------------------

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.0, 0.5, curve: Curves.easeIn),
        )
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.3, 0.8, curve: Curves.easeOut),
        )
    );

    _animationController.forward();

    // جلب الشركات عند فتح الشاشة
    _fetchCompanies();
  }

  // --- دالة جلب الشركات ---
  Future<void> _fetchCompanies() async {
    setState(() {
      _isCompaniesLoading = true;
      _companyError = null;
    });

    final url = Uri.parse('http://salwmynew.ddns.net:7101/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/SeCompanyVRO1');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        final List items = jsonResponse['items'];
        setState(() {
          _companies = items.map((item) => CompanyModel.fromJson(item)).toList();
          // إذا كانت هناك شركة واحدة فقط، قم باختيارها تلقائياً
          if (_companies.length == 1) {
            _selectedCompany = _companies.first;
          }
          _isCompaniesLoading = false;
        });
      } else {
        setState(() {
          _companyError = "فشل تحميل الشركات";
          _isCompaniesLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _companyError = "خطأ في الاتصال";
        _isCompaniesLoading = false;
      });
      debugPrint("Error fetching companies: $e");
    }
  }
  // -----------------------

  @override
  void dispose() {
    _userCodeController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String? validateUserCode(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.userCodeValidationError ?? 'يرجى إدخال رقم العميل';
    }
    return null;
  }

  String? validatePassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.passwordValidationError ?? 'يرجى إدخال كلمة المرور';
    }
    return null;
  }

  Future<void> _performLogin() async {
    final l10n = AppLocalizations.of(context)!;

    if (_formKey.currentState!.validate()) {

      // التحقق من اختيار الشركة
      if (_selectedCompany == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("يرجى اختيار الشركة أولاً"), backgroundColor: Colors.red),
        );
        return;
      }

      // هنا المفروض نمرر _selectedCompany.companyCode للـ Provider لاحقاً
      // print("Selected Company Code: ${_selectedCompany!.companyCode}");

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(
        _userCodeController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success && mounted) {
        _showStyledDialog(
          message: l10n.loginSuccessMessage ?? "تم تسجيل الدخول بنجاح",
          isSuccess: true,
          onContinue: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          },
        );
      } else if (mounted) {
        _showStyledDialog(
          message: authProvider.errorMessage ?? l10n.loginErrorMessage ?? "حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.",
          isSuccess: false,
          onContinue: () {
            Navigator.of(context).pop();
          },
        );
      }
    }
  }

  void _showStyledDialog({
    required String message,
    required bool isSuccess,
    required VoidCallback onContinue,
  }) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: _secondaryColor.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSuccess ? Icons.check : Icons.error,
                        color: isSuccess ? _primaryColor : Colors.red,
                        size: 50,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      l10n.systemWelcomeMessage ?? "مرحباً بك في نظام إدارة موارد المؤسسة",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        l10n.continueButton ?? "متابعة",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageSwitcher() {
    return Consumer<LocaleProvider>(
      builder: (context, provider, child) {
        final isArabic = provider.locale?.languageCode == 'ar';
        return Container(
          child: TextButton(
            onPressed: () {
              provider.setLocale(Locale(isArabic ? 'en' : 'ar'));
            },
            style: TextButton.styleFrom(
              backgroundColor: _primaryColor.withOpacity(0.1),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language,
                  color: _primaryColor,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  isArabic ? 'English' : 'العربية',
                  style: TextStyle(
                    color: _primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.locale.languageCode == 'ar';
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _secondaryColor.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              top: 150,
              left: -80,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _secondaryColor.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -20,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _secondaryColor.withOpacity(0.05),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        padding: EdgeInsets.all(30),
                        width: size.width > 500 ? 500 : size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _secondaryColor.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: _buildLanguageSwitcher(),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 110,
                                width: 110,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _primaryColor.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundImage: AssetImage("assets/images/ascon.jpg"),
                                ),
                              ),
                              SizedBox(height: 30),
                              Text(
                                l10n.systemTitle ?? "نظام إدارة موارد المؤسسة",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black12,
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: 80,
                                height: 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: _secondaryColor,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                l10n.loginTitle,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 30),

                              // --- بداية التعديل ---
                              _isCompaniesLoading
                                  ? Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: CircularProgressIndicator(color: _primaryColor),
                              )
                                  : Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: DropdownButtonFormField<CompanyModel>(
                                  isExpanded: true, // <--- هذا السطر هو الحل السحري
                                  value: _selectedCompany,
                                  decoration: InputDecoration(
                                    hintText: "اختر الشركة",
                                    hintStyle: TextStyle(color: Colors.black38),
                                    prefixIcon: Icon(Icons.business, color: _secondaryColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: _secondaryColor.withOpacity(0.5)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: _primaryColor),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.red.shade300),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.red.shade300),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.withOpacity(0.05),
                                  ),
                                  items: _companies.map((company) {
                                    return DropdownMenuItem<CompanyModel>(
                                      value: company,
                                      child: Text(
                                        isArabic ? company.companyDesc : company.companyDescE,
                                        overflow: TextOverflow.ellipsis, // قص النص الزائد
                                        maxLines: 1, // ضمان عدم نزول النص لسطرين
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCompany = value;
                                    });
                                  },
                                  validator: (value) => value == null ? "يرجى اختيار الشركة" : null,
                                ),
                              ),
                              // --- نهاية التعديل ---

                              TextFormField(
                                controller: _userCodeController,
                                style: TextStyle(color: Colors.black87),
                                textDirection: TextDirection.ltr,
                                validator: (value) => validateUserCode(value, l10n),
                                decoration: InputDecoration(
                                  hintText: l10n.userCodeHint,
                                  hintStyle: TextStyle(color: Colors.black38),
                                  prefixIcon: Icon(Icons.supervised_user_circle_rounded, color: _secondaryColor),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: _secondaryColor.withOpacity(0.5)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: _primaryColor),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.red.shade300),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.red.shade300),
                                  ),
                                  errorStyle: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.05),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: _passwordController,
                                style: TextStyle(color: Colors.black87),
                                obscureText: _obscurePassword,
                                textDirection: TextDirection.ltr,
                                validator: (value) => validatePassword(value, l10n),
                                decoration: InputDecoration(
                                  hintText: l10n.passwordHint,
                                  hintStyle: TextStyle(color: Colors.black38),
                                  prefixIcon: Icon(Icons.lock, color: _secondaryColor),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                      color: _secondaryColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: _secondaryColor.withOpacity(0.5)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: _primaryColor),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.red.shade300),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.red.shade300),
                                  ),
                                  errorStyle: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.05),
                                ),
                              ),
                              SizedBox(height: 15),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(_secondaryColor.withOpacity(0.1)),
                                  ),
                                  child: Text(
                                    l10n.forgotPassword ?? "نسيت كلمة المرور؟",
                                    style: TextStyle(
                                      color: _primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 25),
                              authProvider.isLoading
                                  ? Container(
                                width: 50,
                                height: 50,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _secondaryColor.withOpacity(0.2),
                                ),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                                  strokeWidth: 3,
                                ),
                              )
                                  : Container(
                                width: double.infinity,
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _primaryColor.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _performLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    l10n.login,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    l10n.noAccountText ?? "ليس لديك حساب؟",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  TextButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(_secondaryColor.withOpacity(0.1)),
                                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                                    ),
                                    child: Text(
                                      l10n.signUpText ?? "تسجيل جديد",
                                      style: TextStyle(
                                        color: _primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}