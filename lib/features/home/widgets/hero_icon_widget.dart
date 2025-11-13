import 'package:flutter/material.dart';
import 'dart:math' as math;

class HeroIconWidget extends StatefulWidget { // تم تغيير الاسم لـ HeroIconWidget لتجنب التعارض
  const HeroIconWidget({Key? key}) : super(key: key);
  @override
  _HeroIconWidgetState createState() => _HeroIconWidgetState();
}

class _HeroIconWidgetState extends State<HeroIconWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final curveValue = Curves.easeInOut.transform(_controller.value);
        return Transform.rotate(
          angle: (_controller.value * math.pi * 0.05),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6A1B9A).withOpacity(0.3 + (curveValue * 0.2)),
                  blurRadius: 5 + (curveValue * 5),
                  spreadRadius: curveValue * 1,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 18,
              // تأكد من وجود هذا المسار للصورة في مشروعك
              backgroundImage: const AssetImage("assets/images/ascon.jpg"),
              backgroundColor: Colors.grey[200],
            ),
          ),
        );
      },
    );
  }
}