import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/home_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../auth/screens/login_screen.dart';
import '../widgets/user_info_bottom_bar.dart';
import '../models/home_menu_item_data.dart';
import '../widgets/section_with_slider_widget.dart';
import '../widgets/hero_icon_widget.dart';
import '../../purchases/screens/purchase_orders_list_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final List<Color> _sliderItemColors = [
    const Color(0xFF2979FF),
    const Color(0xFF00ACC1),
    const Color(0xFF388E3C),
    const Color(0xFF16C455),
    const Color(0xFF353EE5),
    const Color(0xFF3054AF),
  ];
  int _colorIndex = 0;

  Color _getNextSliderColor() {
    final color = _sliderItemColors[_colorIndex % _sliderItemColors.length];
    _colorIndex++;
    return color;
  }

  @override
  void initState() {
    super.initState();
    print("[HomeScreen] initState called");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("[HomeScreen] addPostFrameCallback called");
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentUser != null && mounted) {
        print("[HomeScreen] Current user exists, loading notifications...");
        Provider.of<HomeProvider>(context, listen: false)
            .loadNotifications(authProvider.currentUser!.usersCode)
            .then((_) {
          if(mounted) {
            print("[HomeScreen] Notifications loaded (or attempt finished).");
            // قد نحتاج إلى setState هنا إذا كان عرض الأقسام يعتمد على شيء ما بعد تحميل الإشعارات
            // لكن بما أن بناء الأقسام لا يعتمد مباشرة على نتيجة الإشعارات، قد لا يكون ضروريًا.
          }
        });
      } else {
        print("[HomeScreen] No current user or widget not mounted in addPostFrameCallback.");
      }
    });
  }

  @override
  void dispose() {
    print("[HomeScreen] dispose called");
    super.dispose();
  }

  PreferredSizeWidget _buildOldStyleAppBar(BuildContext context, AuthProvider authProvider) {
    const appBarColor = Color(0xFF4F46E5);
    return AppBar(
      backgroundColor: appBarColor,
      elevation: 4.0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const HeroIconWidget(),
            Text(
              AppStrings.appName,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton(
              tooltip: 'تسجيل الخروج',
              onPressed: () async {
                await authProvider.logout();
                if (mounted) {
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                }
              },
              icon: const Icon(Icons.logout, color: Colors.white, size: 26),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("[HomeScreen] build called");
    final authProvider = Provider.of<AuthProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context); // listen: true by default
    final user = authProvider.currentUser;

    if (user == null) {
      print("[HomeScreen] User is null, navigating to LoginScreen.");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    _colorIndex = 0; // إعادة تعيين index اللون مع كل بناء

    print("[HomeScreen] Building UI for user: ${user.usersName}");
    print("[HomeScreen] homeProvider.isLoadingNotifications: ${homeProvider.isLoadingNotifications}");
    print("[HomeScreen] homeProvider.notificationError: ${homeProvider.notificationError}");
    print("[HomeScreen] homeProvider.notificationInfo: ${homeProvider.notificationInfo != null}");


    // هذا الجزء سيعرض مؤشر التحميل أو الخطأ فقط إذا لم يتم تحميل بيانات الإشعارات بعد
    // أو إذا كان هناك خطأ. بعد ذلك، سيعرض دائمًا الـ ListView للأقسام.
    Widget bodyContent;

    if (homeProvider.isLoadingNotifications && homeProvider.notificationInfo == null && homeProvider.purchaseNotificationCount == 0) { // تعديل الشرط
      print("[HomeScreen] Displaying loading indicator.");
      bodyContent = const Padding(
        padding: EdgeInsets.symmetric(vertical: 50.0),
        child: Center(child: SpinKitFadingCircle(color: Color(0xFF4F46E5), size: 40.0)),
      );
    } else if (homeProvider.notificationError != null && homeProvider.notificationInfo == null) {
      print("[HomeScreen] Displaying error message: ${homeProvider.notificationError}");
      bodyContent = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "حدث خطأ أثناء تحميل البيانات: ${homeProvider.notificationError!}\nالرجاء محاولة تحديث الصفحة.",
          style: const TextStyle(color: Colors.redAccent, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      print("[HomeScreen] Displaying ListView with sections.");
      // حتى لو كانت الإشعارات لا تزال تُحمّل في الخلفية (للتحديث) أو إذا كان هناك خطأ ولكن لدينا بيانات قديمة،
      // سنقوم بعرض الأقسام.
      bodyContent = ListView(
        padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
        children: <Widget>[
          _buildPurchasesSectionWithSlider(context, homeProvider),
          _buildHRSectionWithSlider(context, homeProvider),
          _buildCustodySectionWithSlider(context, homeProvider),
          _buildMaintenanceSectionWithSlider(context, homeProvider),
          _buildAboutCompanySectionWithSlider(context, homeProvider),
        ],
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor.withOpacity(0.97),
        appBar: _buildOldStyleAppBar(context, authProvider),
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  print("[HomeScreen] Refresh initiated.");
                  if (mounted) {
                    await homeProvider.loadNotifications(user.usersCode);
                    print("[HomeScreen] Refresh completed.");
                  }
                },
                color: const Color(0xFF4F46E5),
                child: bodyContent, // استخدام bodyContent هنا
              ),
            ),
            const UserInfoBottomBar(),
          ],
        ),
      ),
    );
  }

  // دوال بناء الأقسام (كما هي من الرد السابق، مع التأكد من أنها تُرجع menuItems غير فارغة)
  Widget _buildPurchasesSectionWithSlider(BuildContext context, HomeProvider homeProvider) {
    final int notificationCount = homeProvider.purchaseNotificationCount;
    print("[HomeScreen] Building Purchases Section. Notifications: $notificationCount");
    List<HomeMenuItemData> items = [
      HomeMenuItemData(
        title: 'أوامر الشراء ',
        icon: Icons.playlist_add_check_circle_rounded,
        color: _getNextSliderColor(),
        notificationCount: notificationCount > 0 ? notificationCount : null, // فقط إذا كانت أكبر من صفر
        onTap: () {
          Navigator.of(context).pushNamed(PurchaseOrdersListScreen.routeName);
        },
      ),
      HomeMenuItemData(
        title: 'طلبات الشراء',
        icon: Icons.add_shopping_cart_rounded,
        color: _getNextSliderColor(),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('شاشة طلبات الشراء (سيتم تنفيذها)')),
          );
        },
      ),
    ];
    if (items.isEmpty) print("[HomeScreen] Purchases items are empty!");
    return SectionWithSliderWidget(
      sectionTitle: 'المشتريات',
      sectionIcon: Icons.shopping_cart_checkout_rounded,
      sectionNotificationCount: notificationCount > 0 ? notificationCount : null,
      menuItems: items,
    );
  }

  Widget _buildHRSectionWithSlider(BuildContext context, HomeProvider homeProvider) {
    print("[HomeScreen] Building HR Section.");
    List<HomeMenuItemData> items = [
      HomeMenuItemData(
        title: 'طلبات الإجازات والمغادرات',
        icon: Icons.flight_takeoff_rounded,
        color: _getNextSliderColor(),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('شاشة طلبات الإجازات (سيتم تنفيذها)')),
          );
        },
      ),
      HomeMenuItemData(
        title: 'عرض قسيمة الراتب',
        icon: Icons.request_quote_rounded,
        color: _getNextSliderColor(),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('شاشة قسيمة الراتب (سيتم تنفيذها)')),
          );
        },
      ),
    ];
    if (items.isEmpty) print("[HomeScreen] HR items are empty!");
    return SectionWithSliderWidget(
      sectionTitle: 'خدمات الموارد البشرية',
      sectionIcon: Icons.groups_2_rounded,
      menuItems: items,
    );
  }

  Widget _buildCustodySectionWithSlider(BuildContext context, HomeProvider homeProvider) {
    print("[HomeScreen] Building Custody Section.");
    List<HomeMenuItemData> items = [
      HomeMenuItemData(
        title: 'عرض العهد المسلمة',
        icon: Icons.list_alt_rounded,
        color: _getNextSliderColor(),
        onTap: () { /* TODO */ },
      ),
      HomeMenuItemData(
        title: 'تقديم طلب عهدة',
        icon: Icons.add_box_rounded,
        color: _getNextSliderColor(),
        onTap: () { /* TODO */ },
      ),
    ];
    if (items.isEmpty) print("[HomeScreen] Custody items are empty!");
    return SectionWithSliderWidget(
      sectionTitle: 'إدارة العهد',
      sectionIcon: Icons.inventory_rounded,
      menuItems: items,
    );
  }

  Widget _buildMaintenanceSectionWithSlider(BuildContext context, HomeProvider homeProvider) {
    print("[HomeScreen] Building Maintenance Section.");
    List<HomeMenuItemData> items = [
      HomeMenuItemData(
        title: 'تسجيل طلب صيانة جديد',
        icon: Icons.construction_rounded,
        color: _getNextSliderColor(),
        onTap: () { /* TODO */ },
      ),
      HomeMenuItemData(
        title: 'متابعة حالة الطلبات',
        icon: Icons.history_toggle_off_rounded,
        color: _getNextSliderColor(),
        onTap: () { /* TODO */ },
      ),
    ];
    if (items.isEmpty) print("[HomeScreen] Maintenance items are empty!");
    return SectionWithSliderWidget(
      sectionTitle: 'الورش وطلبات الصيانة',
      sectionIcon: Icons.build_circle_rounded,
      menuItems: items,
    );
  }

  Widget _buildAboutCompanySectionWithSlider(BuildContext context, HomeProvider homeProvider) {
    print("[HomeScreen] Building About Company Section.");
    List<HomeMenuItemData> items = [
      HomeMenuItemData(
        title: 'معلومات تعريفية بالشركة',
        icon: Icons.info_rounded,
        color: _getNextSliderColor(),
        onTap: () { /* TODO */ },
      ),
      HomeMenuItemData(
        title: 'فروعنا ووسائل الاتصال',
        icon: Icons.contact_support_rounded,
        color: _getNextSliderColor(),
        onTap: () { /* TODO */ },
      ),
    ];
    if (items.isEmpty) print("[HomeScreen] About Company items are empty!");
    return SectionWithSliderWidget(
      sectionTitle: 'عن الشركة والتواصل',
      sectionIcon: Icons.business_center_rounded,
      menuItems: items,
    );
  }
}