import 'package:flutter/material.dart';
import 'dart:async'; // لاستخدام Timer
import '../../../core/utils/app_colors.dart';

class MenuSectionWidget extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Widget> children; // العناصر الفرعية التي ستعرض في الـ Slide Show
  final int? notificationCount;

  const MenuSectionWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.notificationCount,
  });

  @override
  State<MenuSectionWidget> createState() => _MenuSectionWidgetState();
}

class _MenuSectionWidgetState extends State<MenuSectionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // للـ PageView (Slide Show)
  final PageController _pageController = PageController(viewportFraction: 0.85, initialPage: 0); // viewportFraction لجعل جزء من الشريحة التالية ظاهرًا
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _entryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryAnimationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryAnimationController, curve: Curves.easeOut),
    );

    _entryAnimationController.forward();

    // بدء الـ Timer لتحريك الـ Slide Show تلقائيًا إذا كان هناك أكثر من عنصر
    if (widget.children.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
        if (_currentPage < widget.children.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (_pageController.hasClients) { // التأكد أن الـ controller متصل بـ PageView
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeInOutCubic,
          );
        }
      });
    }

    _pageController.addListener(() {
      if (_pageController.page != null && mounted) { // التحقق من mounted
        setState(() {
          // تحديث _currentPage بناءً على تمرير المستخدم (اختياري إذا أردت إبقاء التحكم التلقائي فقط)
          // _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _entryAnimationController.dispose();
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // التأكد من وجود عناصر قبل محاولة بناء الـ PageView
    if (widget.children.isEmpty) {
      return const SizedBox.shrink(); // أو عرض رسالة بديلة
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column( // استخدام Column لوضع العنوان فوق الـ SlideShow
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- عنوان القسم ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0), // زيادة الـ padding العلوي
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [

                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 19, // تكبير خط العنوان قليلاً
                          fontWeight: FontWeight.w600, // أقل سمكًا قليلاً من bold
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(widget.icon, color: AppColors.primaryColor, size: 24), // تصغير الأيقونة قليلاً

                    ],
                  ),
                  if (widget.notificationCount != null && widget.notificationCount! > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.errorColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.notificationCount.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
            // --- Slide Show ---
            SizedBox(
              height: 120, // ارتفاع مناسب لعناصر القائمة داخل الـ Slide Show
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.children.length,
                onPageChanged: (int page) {
                  if(mounted){ // التحقق من mounted
                    setState(() {
                      _currentPage = page;
                    });
                  }
                },
                itemBuilder: (context, index) {
                  // تطبيق تأثير انكماش بسيط على العناصر غير النشطة
                  double scale = _currentPage == index ? 1.0 : 0.92;
                  // إضافة هامش بين عناصر الـ PageView
                  return Transform.scale(
                    scale: scale,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0), // هامش للعنصر
                      decoration: BoxDecoration(
                          color: Colors.white, // خلفية بيضاء لكل عنصر في السلايد
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.hintColor.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: _currentPage == index
                                ? AppColors.primaryColor.withOpacity(0.5)
                                : Colors.grey.withOpacity(0.2),
                            width: _currentPage == index ? 1.5 : 0.8,
                          )
                      ),
                      child: ClipRRect( // لضمان أن المحتوى لا يتجاوز الحدود الدائرية
                          borderRadius: BorderRadius.circular(11.0), // أقل بقليل من حدود الكارت
                          child: widget.children[index]
                      ),
                    ),
                  );
                },
              ),
            ),
            // --- مؤشر النقاط للـ Slide Show ---
            if (widget.children.length > 1) // فقط إذا كان هناك أكثر من عنصر
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.children.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                    width: _currentPage == index ? 12.0 : 8.0,
                    height: _currentPage == index ? 12.0 : 8.0,
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.circular(_currentPage == index ? 6 : 4),
                      color: _currentPage == index
                          ? AppColors.primaryColor
                          : AppColors.hintColor.withOpacity(0.4),
                    ),
                  );
                }),
              ),
            const SizedBox(height: 10), // مسافة بعد كل قسم
          ],
        ),
      ),
    );
  }
}

// MenuListItem سيبقى كما هو (من الرد السابق، كان جيدًا)
// لكننا سنقوم بتعديل بسيط في الـ padding وأيقونة السهم
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
    return Material( // استخدام Material لـ InkWell
      color: Colors.transparent, // جعله شفافًا ليأخذ لون الـ Container الأعلى
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11.0), // ليطابق ClipRRect
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // تعديل الحشوة
          child: Row(
            children: [
              Container( // إضافة خلفية دائرية للأيقونة
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primaryColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 15.5, // تكبير الخط قليلاً
                          color: AppColors.textColor.withOpacity(0.95),
                          fontWeight: FontWeight.w500), // جعله أثقل قليلاً
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // يمكنك إضافة وصف صغير هنا إذا أردت
                    // Text("وصف صغير للخدمة", style: TextStyle(fontSize: 12, color: AppColors.hintColor)),
                  ],
                ),
              ),
              if (notificationCount != null && notificationCount! > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0), // إضافة مسافة قبل الإشعار
                  child: Container(
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
                ),
              // إزالة أيقونة السهم الأمامي، لأن العنصر بأكمله قابل للنقر
              // const SizedBox(width: 8),
              // const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.hintColor),
            ],
          ),
        ),
      ),
    );
  }
}