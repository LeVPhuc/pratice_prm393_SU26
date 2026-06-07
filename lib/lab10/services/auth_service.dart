import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final String _loginUrl = 'https://dummyjson.com/auth/login';

  // 1. Hàm xử lý đăng nhập bằng REST API thật (Lab 10.2)
  Future<UserModel?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'expiresInMins': 30, // Session hết hạn sau 30 phút
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        UserModel user = UserModel.fromJson(responseData);

        // Lưu trạng thái đăng nhập vào thiết bị (Lab 10.3 Session)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
        await prefs.setString('user_token', user.token);
        await prefs.setString('user_name', '${user.firstName} ${user.lastName}');
        await prefs.setString('user_avatar', user.image);

        return user;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Sai tài khoản hoặc mật khẩu!');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // 2. Kiểm tra xem người dùng đã đăng nhập trước đó chưa (Auto-Login Lab 10.3)
  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // 3. Đăng xuất xóa sạch dữ liệu phiên làm việc (Lab 10.3 Logout)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Xóa sạch token và trạng thái login khỏi thiết bị
  }
}