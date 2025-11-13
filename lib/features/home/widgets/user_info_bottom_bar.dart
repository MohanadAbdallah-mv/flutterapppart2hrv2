import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../../user_profile/screens/user_profile_screen.dart';

class UserInfoBottomBar extends StatelessWidget {
  const UserInfoBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return const SizedBox.shrink();
    }

    final String placeholderImageUrl = 'https://picsum.photos/seed/${user.usersCode}/100';

    return Material(
      elevation: 8.0,
      color: AppColors.backgroundColor, // أو Theme.of(context).cardColor إذا أردت لون البطاقة
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: user.compEmpCode);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.primaryColor.withOpacity(0.2), width: 0.8),
            ),
          ),
          // استخدام Directionality للتحكم في اتجاه العناصر
          child: Directionality(
            textDirection: TextDirection.rtl, // <--- تحديد الاتجاه من اليمين لليسار
            child: Row(
              children: [
                // الصورة أولاً (على اليمين في RTL)
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.8),
                  child: CachedNetworkImage(
                    imageUrl: placeholderImageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.accentColor,
                      child: Text(
                        user.usersName.isNotEmpty ? user.usersName[0].toUpperCase() : 'U',
                        style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // النصوص (ستكون في المنتصف)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // النصوص ستبدأ من اليمين داخل هذا العمود
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.usersName,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor),
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.rtl, // تأكيد اتجاه النص
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ' ${user.jobDesc}',
                        style: TextStyle(fontSize: 13, color: AppColors.textColor.withOpacity(0.7)),
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.rtl, // تأكيد اتجاه النص
                      ),
                    ],
                  ),
                ),
                // أيقونة السهم (ستكون على اليسار في RTL)
                const Icon(Icons.arrow_back_ios_new, color: AppColors.hintColor, size: 18), // استخدام سهم يشير للخلف في RTL
              ],
            ),
          ),
        ),
      ),
    );
  }
}