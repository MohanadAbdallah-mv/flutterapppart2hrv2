import 'dart:async';
import 'package:flutter/material.dart';
import '../models/home_menu_item_data.dart';
// تأكد من استيراد AppColors إذا كنت ستستخدم ألوانًا محددة منه بدلًا من Color(0xFF4F46E5)
// import '../../../core/utils/app_colors.dart';


class SectionWithSliderWidget extends StatefulWidget {
  final String sectionTitle;
  final IconData sectionIcon;
  final List<HomeMenuItemData> menuItems;
  final int? sectionNotificationCount;

  const SectionWithSliderWidget({
    Key? key,
    required this.sectionTitle,
    required this.sectionIcon,
    required this.menuItems,
    this.sectionNotificationCount,
  }) : super(key: key);

  @override
  _SectionWithSliderWidgetState createState() => _SectionWithSliderWidgetState();
}

class _SectionWithSliderWidgetState extends State<SectionWithSliderWidget> with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoSlideTimer;
  late AnimationController _sliderItemPressAnimationController; // تم تغيير الاسم للوضوح

  final Color _categoryTitleColor = const Color(0xFF4F46E5); // لون عنوان القسم

  @override
  void initState() {
    super.initState();
    print("[SectionWithSliderWidget - ${widget.sectionTitle}] initState called. Items: ${widget.menuItems.length}");

    // التعامل مع حالة وجود عنصر واحد فقط في PageController
    // viewportFraction يجب أن يكون أقل من 1.0 حتى لو كان هناك عنصر واحد ليعمل بشكل صحيح مع بعض الأنيميشنز
    // لكن إذا كان عنصر واحد، قد لا تحتاج لـ PageController معقد.
    // للحفاظ على نفس التصميم، سنستخدم viewportFraction: 0.85 حتى لو عنصر واحد.
    // يمكن تعديل هذا إذا كان المظهر غير مرغوب فيه لعنصر واحد.
    double viewportFractionValue = widget.menuItems.length > 1 ? 0.85 : 1.0; // إذا عنصر واحد، خليه يملأ العرض
    // إذا كان عنصر واحد، قد لا يكون هناك معنى لـ initialPage إذا كان viewportFraction هو 1.0
    // لكن لتجنب مشاكل محتملة، سنبقيه 0.

    _pageController = PageController(
      initialPage: 0, // دائمًا ابدأ من الصفر
      viewportFraction: viewportFractionValue,
    );

    _pageController.addListener(() {
      if (_pageController.page != null) {
        final newPage = _pageController.page!.round();
        // التأكد أن newPage ضمن حدود قائمة العناصر
        if (newPage >= 0 && newPage < widget.menuItems.length && _currentPage != newPage && mounted) {
          setState(() {
            _currentPage = newPage;
          });
        } else if (widget.menuItems.isEmpty && _currentPage != 0 && mounted){ // إذا أصبحت القائمة فارغة
          setState(() {
            _currentPage = 0;
          });
        }
      }
    });

    _sliderItemPressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    if (widget.menuItems.length > 1) {
      _startAutoSlide();
    }
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) { // زيادة المدة قليلاً
      if (mounted && widget.menuItems.isNotEmpty && widget.menuItems.length > 1) { // التأكد أن هناك أكثر من عنصر للسلايد
        int nextPage = (_currentPage + 1) % widget.menuItems.length;
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOutCubic,
          );
        } else {
          // إذا لم يكن الـ PageController متصلاً بعد، حاول إعادة تعيين _currentPage
          if(mounted) setState(() { _currentPage = nextPage; });
        }
      } else {
        timer.cancel(); // إيقاف الـ Timer إذا لم تعد الشروط متحققة
      }
    });
  }

  @override
  void dispose() {
    print("[SectionWithSliderWidget - ${widget.sectionTitle}] dispose called");
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    _sliderItemPressAnimationController.dispose();
    super.dispose();
  }

  Widget _buildCategoryTitle(String title, IconData icon, int? notificationCount) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 18, bottom: 10.0), // تعديل الـ padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: _categoryTitleColor, size: 22), // تصغير الأيقونة قليلاً
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18, // تعديل حجم الخط
                  fontWeight: FontWeight.bold, // جعل الخط أثقل
                  color: _categoryTitleColor,
                ),
              ),
            ],
          ),
          if (notificationCount != null && notificationCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), // تعديل الحشوة
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(10), // تعديل دائرية الحواف
              ),
              child: Text(
                notificationCount.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11, // تصغير الخط
                    fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainServicesSlider() {
    if (widget.menuItems.isEmpty) {
      print("[SectionWithSliderWidget - ${widget.sectionTitle}] No items to build slider.");
      // عرض حاوية بنفس الارتفاع ولكن فارغة أو برسالة
      return SizedBox(
        height: 145, // نفس ارتفاع الـ PageView + PageIndicator التقريبي
        child: Center(
            child: Text(
              "لا توجد عناصر لعرضها حاليًا.",
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            )),
      );
    }
    print("[SectionWithSliderWidget - ${widget.sectionTitle}] Building slider with ${widget.menuItems.length} items. Current page: $_currentPage");

    return SizedBox(
      height: 120, // ارتفاع الـ PageView فقط
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.menuItems.length,
        // onPageChanged: تم نقله إلى listener في initState لضمان التحديث المستمر
        itemBuilder: (context, index) {
          double scale = 1.0;
          if (_pageController.position.haveDimensions) {
            double page = _pageController.page ?? _currentPage.toDouble();
            // التأكد أن index ضمن الحدود
            if (index >=0 && index < widget.menuItems.length) {
              scale = 1.0 - (page - index).abs() * 0.12;
              scale = scale.clamp(0.88, 1.0);
            }
          } else if (index != _currentPage) { // حالة قبل أن يكون للـ controller أبعاد
            scale = 0.88;
          }
          // التأكد أن index ضمن الحدود قبل محاولة الوصول للعنصر
          if (index >= widget.menuItems.length || index < 0) return const SizedBox.shrink();
          return _buildSliderItem(widget.menuItems[index], index, scale);
        },
      ),
    );
  }

  Widget _buildSliderItem(HomeMenuItemData item, int index, double scale) {
    // التأكد أن _currentPage ضمن الحدود قبل استخدامه للمقارنة
    bool isActive = (index == _currentPage && _currentPage < widget.menuItems.length && _currentPage >=0 );
    print("[SectionWithSliderWidget - ${widget.sectionTitle}] Building slider item $index. Title: ${item.title}. IsActive: $isActive. Scale: $scale");

    return Transform.scale(
      scale: scale,
      child: GestureDetector(
        onTapDown: (_) {
          if (isActive && mounted) _sliderItemPressAnimationController.forward();
        },
        onTapUp: (_) {
          if (mounted) {
            _sliderItemPressAnimationController.reverse().then((value) {
              if (mounted) item.onTap(); // استدعاء onTap بعد اكتمال الأنيميشن
            });
          } else {
            item.onTap(); // استدعاء onTap مباشرة إذا لم يكن mounted (غير محتمل هنا)
          }
        },
        onTapCancel: () {
          if (mounted) _sliderItemPressAnimationController.reverse();
        },
        child: AnimatedBuilder(
          animation: _sliderItemPressAnimationController,
          builder: (context, child) {
            double pressScale = isActive ? (1 - (_sliderItemPressAnimationController.value * 0.03)) : 1.0;
            return Transform.scale(
              scale: pressScale,
              child: child,
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 6.0), // تعديل الهوامش
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.97),
              borderRadius: BorderRadius.circular(16), // تعديل دائرية الحواف
              boxShadow: [
                BoxShadow(
                  color: item.color.withOpacity(isActive ? 0.45 : 0.25),
                  blurRadius: isActive ? 9 : 5,
                  offset: Offset(0, isActive ? 4 : 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                splashColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0), // تعديل الحشوة
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        margin: const EdgeInsets.only(left: 10, right: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3), // زيادة الشفافية قليلاً
                          shape: BoxShape.circle,
                        ),
                        child: Icon(item.icon, size: 26, color: Colors.white),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 15, // تعديل حجم الخط
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 2, // السماح بسطرين
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (item.notificationCount != null && item.notificationCount! > 0) ...[
                              const SizedBox(height: 3),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9), // خلفية بيضاء للإشعار
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Text(
                                  item.notificationCount.toString(),
                                  style: TextStyle(
                                    color: item.color, // لون الإشعار بلون الكارت
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ]
                          ],
                        ),
                      ),
                      Padding( // إضافة Padding حول الأيقونة
                        padding: const EdgeInsets.only(left: 6.0, right: 2.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white.withOpacity(0.75),
                          size: 16, // تصغير السهم قليلاً
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    if (widget.menuItems.length <= 1) return const SizedBox(height: 25);

    return SizedBox(
      height: 25,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.menuItems.length, (index) {
            // التأكد أن index و _currentPage ضمن الحدود قبل الوصول للعناصر
            bool isActive = index == _currentPage && _currentPage < widget.menuItems.length && _currentPage >=0;
            Color dotColor = Colors.grey.withOpacity(0.4); // لون افتراضي

            if (isActive && widget.menuItems.isNotEmpty) {
              dotColor = widget.menuItems[_currentPage].color.withOpacity(0.9);
            }

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4.0), // تعديل المسافة
              height: isActive ? 10 : 7.5, // تعديل الحجم
              width: isActive ? 10 : 7.5,  // تعديل الحجم
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                  boxShadow: isActive ? [
                    BoxShadow(
                        color: dotColor.withOpacity(0.6), // زيادة وضوح الظل
                        blurRadius: 4,
                        spreadRadius: 1
                    )
                  ] : []
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("[SectionWithSliderWidget - ${widget.sectionTitle}] build called. Items: ${widget.menuItems.length}");
    if (widget.menuItems.isEmpty && !mounted) { // إضافة تحقق من mounted هنا أيضاً
      // إذا لم يكن هناك عناصر والويدجت لم يعد mounted (نادر ولكن للاحتياط)
      return const SizedBox.shrink();
    }

    return Column( // لا نحتاج لـ SlideTransition و FadeTransition هنا إذا كان الأنيميشن داخل HomeScreen
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoryTitle(widget.sectionTitle, widget.sectionIcon, widget.sectionNotificationCount),
        // التحقق هنا بشكل صريح قبل بناء الـ Slider والـ Indicator
        widget.menuItems.isNotEmpty
            ? _buildMainServicesSlider()
            : Container(
          height: 120, // ارتفاع مشابه للسلايدر
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16)
          ),
          child: Text(
            "لا توجد خدمات متاحة حالياً في هذا القسم.",
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        if(widget.menuItems.isNotEmpty) _buildPageIndicator(), // فقط إذا كانت هناك عناصر
        if(widget.menuItems.isEmpty) const SizedBox(height: 25), // للحفاظ على مسافة إذا كان فارغًا

        const SizedBox(height: 8), // تقليل المسافة السفلية
      ],
    );
  }
}