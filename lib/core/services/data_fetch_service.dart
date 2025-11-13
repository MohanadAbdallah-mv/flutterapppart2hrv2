import 'dart:convert'; // لاستخدام utf8 و json
import 'package:http/http.dart' as http;
import '../api/api_constants.dart';
import '../models/notification_model.dart';
import '../models/user_profile_model.dart';
import '../models/purchase_order_model.dart';

class DataFetchService {
  // دالة مساعدة لطباعة تفاصيل الخطأ بشكل أفضل
  void _printErrorDetails(String functionName, http.Response response) {
    print('$functionName failed with status code: ${response.statusCode}');
    try {
      // محاولة طباعة الجسم بعد فك ترميزه إذا أمكن، أو كجسم خام
      print('Response body (UTF-8 decoded for error): ${utf8.decode(response.bodyBytes)}');
    } catch (e) {
      print('Response body (raw, could not decode for error): ${response.body}');
      print('Error decoding response body for logging: $e');
    }
  }

  Future<NotificationItem?> fetchUserNotifications(int usersCode) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userTransactionsInfoEndpoint}?q=UsersCode=$usersCode'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> decodedResponse = json.decode(responseBody);
        if (decodedResponse.containsKey('items') &&
            decodedResponse['items'] is List &&
            (decodedResponse['items'] as List).isNotEmpty) {
          return NotificationItem.fromJson(decodedResponse['items'][0]);
        }
        return null; // لا توجد بيانات أو تنسيق غير متوقع
      } else {
        _printErrorDetails('fetchUserNotifications', response);
        throw Exception('Failed to load user notifications. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchUserNotifications: $e');
      throw Exception('An error occurred while fetching user notifications: $e');
    }
  }

  Future<UserProfileData?> fetchUserProfile(int compEmpCode) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userSalaryInfoEndpoint}?q=CompEmpCode=$compEmpCode'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> decodedResponse = json.decode(responseBody);
        if (decodedResponse.containsKey('items') &&
            decodedResponse['items'] is List &&
            (decodedResponse['items'] as List).isNotEmpty) {
          return UserProfileData.fromJson(decodedResponse['items'][0]);
        }
        print('User profile data not found or empty for CompEmpCode: $compEmpCode');
        return null;
      } else {
        _printErrorDetails('fetchUserProfile', response);
        throw Exception('Failed to load user profile. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchUserProfile: $e');
      throw Exception('An error occurred while fetching user profile: $e');
    }
  }

  Future<List<PurchaseOrderItem>> fetchPurchaseOrders(int usersCode) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.purchaseOrdersEndpoint}?q=UsersCode=$usersCode'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> decodedResponse = json.decode(responseBody);
        if (decodedResponse.containsKey('items') && decodedResponse['items'] is List) {
          List<dynamic> itemsJson = decodedResponse['items'];
          return itemsJson.map((jsonItem) => PurchaseOrderItem.fromJson(jsonItem)).toList();
        }
        return []; // لا توجد أوامر شراء
      } else {
        _printErrorDetails('fetchPurchaseOrders', response);
        throw Exception('Failed to load purchase orders. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchPurchaseOrders: $e');
      throw Exception('An error occurred while fetching purchase orders: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchDataFromUrl(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url), // الـ URL هنا يجب أن يكون كاملًا
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        return json.decode(responseBody) as Map<String, dynamic>;
      } else {
        _printErrorDetails('fetchDataFromUrl (URL: $url)', response);
        // يمكنك اختيار إرجاع null أو throw Exception بناءً على كيفية معالجة الخطأ في الـ Provider
        return null;
      }
    } catch (e) {
      print('Error in fetchDataFromUrl (URL: $url): $e');
      // يمكنك اختيار إرجاع null أو throw Exception
      return null;
    }
  }
}