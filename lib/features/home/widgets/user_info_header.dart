import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart'; // لعرض صورة من الإنترنت

import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../../user_profile/screens/user_profile_screen.dart'; // سننشئ هذه الصفحة لاحقًا

class UserInfoHeader extends StatelessWidget {
  const UserInfoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return const SizedBox.shrink(); // لا تعرض شيئًا إذا لم يتم تسجيل دخول المستخدم
    }

    // يمكنك استخدام صورة حقيقية إذا كانت متوفرة في الـ API، أو صورة افتراضية
    final String placeholderImageUrl = 'https://picsum.photos/150';

    return GestureDetector(
      onTap: () {
        // الانتقال إلى صفحة تفاصيل المستخدم عند الضغط
        Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: user.compEmpCode);
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: AppColors.primaryColor,
              // foregroundImage: NetworkImage(user.profileImageUrl ?? placeholderImageUrl), // إذا كان لديك رابط صورة
              child: CachedNetworkImage(
                imageUrl: placeholderImageUrl, // استخدم الصورة من الإنترنت أو صورة محلية
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => const CircularProgressIndicator(color: Colors.white),
                errorWidget: (context, url, error) => Text(
                  user.usersName.isNotEmpty ? user.usersName[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.usersName,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'الكود: ${user.compEmpCode}',
                    style: TextStyle(fontSize: 14, color: AppColors.textColor.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.jobDesc,
                    style: TextStyle(fontSize: 14, color: AppColors.textColor.withOpacity(0.7)),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'الجنسية: ${user.ntnltyDesc}',
                    style: TextStyle(fontSize: 14, color: AppColors.textColor.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.primaryColor, size: 18),
          ],
        ),
      ),
    );
  }
}