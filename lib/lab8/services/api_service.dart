import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class ApiService {
  // Endpoint URL lấy danh sách bài viết mẫu
  final String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        // Giải mã chuỗi JSON trả về thành danh sách động (List)
        List<dynamic> data = jsonDecode(response.body);

        // Duyệt qua từng phần tử JSON và ép kiểu sang đối tượng Post
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        // Xử lý khi API trả về mã lỗi (Ví dụ: 404, 500)
        throw Exception('Không thể tải dữ liệu từ máy chủ (Mã lỗi: ${response.statusCode})');
      }
    } catch (e) {
      // Xử lý lỗi kết nối mạng (Mất mạng, sai URL, timeout)
      throw Exception('Lỗi kết nối: Vui lòng kiểm tra lại mạng Internet của bạn.');
    }
  }
}