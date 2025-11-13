import 'dart:convert'; // للتأكد من وجود utf8
import 'package:http/http.dart' as http;
import '../api/api_constants.dart';
import '../models/user_model.dart';

class AuthService {
  Future<User?> login(String usersCode, String password) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}'),
        headers: {'Content-Type': 'application/json'}, // هذا Header للطلب، ليس للاستجابة
      );

      if (response.statusCode == 200) {
        // فك ترميز الاستجابة باستخدام UTF-8
        String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> decodedResponse = json.decode(responseBody);

        if (decodedResponse.containsKey('items') && decodedResponse['items'] is List) {
          final List<dynamic> usersData = decodedResponse['items'];
          for (var userData in usersData) {
            if (userData is Map<String, dynamic>) {
              if (userData.containsKey('UsersCode') && userData.containsKey('Password')) {
                final user = User.fromJson(userData);
                if (user.usersCode.toString() == usersCode && user.password == password) {
                  return user;
                }
              }
            }
          }
        }
        return null;
      } else {
        print('Login failed with status code: ${response.statusCode}');
        // حاول طباعة الاستجابة كنص لمعرفة ما إذا كانت قابلة للقراءة هنا
        try {
          print('Response body (raw): ${response.body}');
          print('Response body (UTF-8 decoded): ${utf8.decode(response.bodyBytes)}');
        } catch (e) {
          print('Could not decode response body for error logging: $e');
        }
        throw Exception('Failed to load users from API. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('An error occurred during login: $e');
    }
  }


  // --== الدالة الجديدة لجلب المستخدم بالكود ==--
  Future<User?> getUser(String usersCode) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        final List<User> users = userFromJson(responseBody);
        for (var user in users) {
          if (user.usersCode.toString() == usersCode) {
            return user; // إرجاع المستخدم بمجرد العثور عليه
          }
        }
        return null; // لم يتم العثور على المستخدم
      } else {
        throw Exception('Failed to load user data.');
      }
    } catch (e) {
      print('Error getting user by code: $e');
      throw Exception('An error occurred while fetching user data: $e');
    }
  }
}