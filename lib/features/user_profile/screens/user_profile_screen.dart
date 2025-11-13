import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';

class UserProfileScreen extends StatefulWidget {
  static const String routeName = '/user-profile';
  final int compEmpCode;

  const UserProfileScreen({super.key, required this.compEmpCode});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false)
          .loadUserProfile(widget.compEmpCode);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // دالة لاختيار النص المناسب حسب اللغة
  String _getLocalizedText(String? arabicText, String? englishText, bool isArabic) {
    if (isArabic) {
      return arabicText ?? englishText ?? 'غير متوفر';
    } else {
      return englishText ?? arabicText ?? 'Not available';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final profile = userProvider.userProfileData;
    final isArabic = localeProvider.locale.languageCode == 'ar';
    final l10n = AppLocalizations.of(context)!;

    final currencyFormat = NumberFormat.currency(
        locale: isArabic ? 'ar_SA' : 'en_US',
        symbol: isArabic ? 'ر.س' : 'SAR'
    );

    Widget buildDetailRow(String label, String? value, {bool isCurrency = false, IconData? icon}) {
      String displayValue = value ?? (isArabic ? 'غير متوفر' : 'Not available');
      if (value != null && isCurrency) {
        try {
          displayValue = currencyFormat.format(double.tryParse(value) ?? 0.0);
        } catch (e) {
          displayValue = isArabic
              ? '$value ر.س (تنسيق غير صالح)'
              : '$value SAR (Invalid format)';
        }
      }

      return
        Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.primaryColor, size: 20),
              const SizedBox(width: 10),
            ],
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor),
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Text(
                displayValue,
                style: TextStyle(fontSize: 15, color: AppColors.textColor.withOpacity(0.85)),
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
              ),
            ),
          ],
        ),
      );
    }

    Widget buildSectionTitle(String title) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 8.0, right: 16.0, left: 16.0),
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor),
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
        ),
      );
    }
    /*
    onTap: () {
      localeProvider.toggleLocale();
    },*/
    Widget buildLanguageToggleButton() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              localeProvider.toggleLocale();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical:  8
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.language,
                    color: Colors.white,
                    size:  18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    localeProvider.locale.languageCode == 'en' ? 'العربية' : 'English',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(isArabic ? 'تفاصيل الملف الشخصي' : 'Profile Details',style: TextStyle(fontSize:16 ),),
          backgroundColor: AppColors.primaryColor,
          actions: [
            buildLanguageToggleButton(),
            SizedBox(width: 5,),
          ],
        ),
        body: userProvider.isLoadingProfile
            ? const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50.0))
            : userProvider.profileError != null
            ? Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              userProvider.profileError!,
              style: const TextStyle(color: AppColors.errorColor, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        )
            : profile == null
            ? Center(
            child: Text(
              isArabic ? 'لم يتم العثور على بيانات للمستخدم.' : 'No user data found.',
              style: const TextStyle(fontSize: 16),
            ))
            : RefreshIndicator(
          onRefresh: () => userProvider.loadUserProfile(widget.compEmpCode),
          child: ListView(
            padding: const EdgeInsets.all(12.0),
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSectionTitle(isArabic ? 'المعلومات الأساسية' : 'Basic Information'),
                      buildDetailRow(
                          isArabic ? 'كود الموظف (الشركة):' : 'Employee Code (Company):',
                          profile.compEmpCode.toString(),
                          icon: Icons.badge_outlined
                      ),
                      buildDetailRow(
                          isArabic ? 'اسم الموظف:' : 'Employee Name:',
                          _getLocalizedText(profile.empName, profile.empNameE, isArabic),
                          icon: Icons.person_outline
                      ),
                      buildDetailRow(
                          isArabic ? 'القسم:' : 'Department:',
                          _getLocalizedText(profile.dNameA, profile.dNameE, isArabic), // ✅ عدّل هنا
                          icon: Icons.business_outlined
                      ),
                      buildDetailRow(
                          isArabic ? 'المسمى الوظيفي:' : 'Job Title:',
                          _getLocalizedText(profile.jobDesc, profile.jobDescE, isArabic),
                          icon: Icons.work_outline
                      ),
                      const Divider(height: 20),

                      buildSectionTitle(isArabic ? 'تفاصيل الراتب والبدلات' : 'Salary and Allowances Details'),
                      buildDetailRow(
                          isArabic ? 'الراتب الأساسي:' : 'Basic Salary:',
                          profile.salary?.toStringAsFixed(2),
                          isCurrency: true,
                          icon: Icons.attach_money_outlined
                      ),
                      buildDetailRow(
                          isArabic ? 'بدل النقل:' : 'Transportation Allowance:',
                          profile.transport?.toStringAsFixed(2),
                          isCurrency: true,
                          icon: Icons.directions_car_outlined
                      ),
                      buildDetailRow(
                          isArabic ? 'بدل طبيعة عمل:' : 'Work Nature Allowance:',
                          profile.nature?.toStringAsFixed(2),
                          isCurrency: true,
                          icon: Icons.nature_people_outlined
                      ),
                      buildDetailRow(
                          isArabic ? 'بدل طعام:' : 'Food Allowance:',
                          profile.food?.toStringAsFixed(2),
                          isCurrency: true,
                          icon: Icons.restaurant_outlined
                      ),
                      buildDetailRow(
                          isArabic ? 'إضافي:' : 'Extra:',
                          profile.extra?.toStringAsFixed(2),
                          isCurrency: true,
                          icon: Icons.add_card_outlined
                      ),
                      buildDetailRow(
                          isArabic ? 'بدلات أخرى:' : 'Other Allowances:',
                          profile.others?.toStringAsFixed(2),
                          isCurrency: true,
                          icon: Icons.card_giftcard_outlined
                      ),
                      buildDetailRow(
                          isArabic ? 'خصومات أخرى:' : 'Other Deductions:',
                          profile.dcsnOthr?.toStringAsFixed(2),
                          isCurrency: true,
                          icon: Icons.money_off_outlined
                      ),
                      buildDetailRow(
                          isArabic ? 'بدل 1:' : 'Allowance 1:',
                          profile.allowance1?.toStringAsFixed(2),
                          isCurrency: true
                      ),
                      buildDetailRow(
                          isArabic ? 'بدل 2:' : 'Allowance 2:',
                          profile.allowance2?.toStringAsFixed(2),
                          isCurrency: true
                      ),
                      buildDetailRow(
                          isArabic ? 'بدل 3:' : 'Allowance 3:',
                          profile.allowance3?.toStringAsFixed(2),
                          isCurrency: true
                      ),
                      const Divider(height: 20),

                      buildSectionTitle(isArabic ? 'معلومات السكن' : 'Housing Information'),
                      buildDetailRow(
                          isArabic ? 'شهور بدل السكن:' : 'Housing Allowance Months:',
                          profile.houseMnths?.toString(),
                          icon: Icons.home_work_outlined
                      ),
                      buildDetailRow(
                          isArabic ? 'مبلغ بدل السكن:' : 'Housing Allowance Amount:',
                          profile.houseAmount?.toStringAsFixed(2),
                          isCurrency: true,
                          icon: Icons.real_estate_agent_outlined
                      ),
                      const Divider(height: 20),

                      buildSectionTitle(isArabic ? 'معلومات الدوام والإجازات' : 'Work Schedule and Vacation Information'),
                      buildDetailRow(
                          isArabic ? 'أيام الدوام العادية:' : 'Normal Working Days:',
                          profile.normalDays?.toString(),
                          icon: Icons.calendar_today_outlined
                      ),
                      buildDetailRow(
                          isArabic ? 'أيام الغياب غير المسموح بها:' : 'Unauthorized Absence Days:',
                          profile.absenceNotAllowExtraDays?.toString(),
                          icon: Icons.event_busy_outlined
                      ),
                      buildDetailRow(
                          isArabic ? 'إجازة كل (شهر/سنة):' : 'Vacation Every (Month/Year):',
                          profile.vacationEvery?.toString(),
                          icon: Icons.flight_takeoff_outlined
                      ),
                      const Divider(height: 20),

                      buildSectionTitle(isArabic ? 'معلومات تذاكر السفر' : 'Travel Tickets Information'),
                      buildDetailRow(
                          isArabic ? 'مبلغ التذاكر:' : 'Tickets Amount:',
                          profile.ticketsAmount?.toStringAsFixed(2),
                          isCurrency: true,
                          icon: Icons.airplane_ticket_outlined
                      ),
                      buildDetailRow(
                          isArabic ? 'تذاكر كل (شهر/سنة):' : 'Tickets Every (Month/Year):',
                          profile.ticketsEvery?.toString()
                      ),
                      buildDetailRow(
                          isArabic ? 'نوع التذاكر:' : 'Tickets Type:',
                          _getLocalizedText(profile.ticketsType, profile.ticketsType, isArabic)
                      ),
                      buildDetailRow(
                          isArabic ? 'مدينة السفر:' : 'Travel City:',
                          _getLocalizedText(profile.cityNameA, profile.cityNameE, isArabic),
                          icon: Icons.location_city_outlined
                      ),
                      buildDetailRow(
                          isArabic ? 'شركة الطيران:' : 'Airline:',
                          _getLocalizedText(profile.airlineNameA, profile.airlineNameE, isArabic),
                          icon: Icons.connecting_airports_outlined
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
  }
}
