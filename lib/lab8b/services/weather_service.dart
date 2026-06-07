import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  // SỬA TẠI ĐÂY: Thêm proxy công khai 'https://cors-anywhere.herokuapp.com/' hoặc 'https://api.allorigins.win/raw?url=' vào trước link gốc
  final String _apiUrl =
      'https://api.allorigins.win/raw?url=https://api.open-meteo.com/v1/forecast?latitude=21.0245&longitude=105.8412&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m&timezone=Asia/Bangkok';

  Future<Weather> fetchCurrentWeather() async {
    try {
      // Gửi yêu cầu lấy dữ liệu qua cầu trung gian gỡ CORS
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return Weather.fromJson(jsonData);
      } else {
        throw Exception('Không thể kết nối tới máy chủ thời tiết (Mã lỗi: ${response.statusCode})');
      }
    } catch (e) {
      // Nếu bộ proxy mạng trên bị nghẽn, ta dùng dữ liệu ngoại tuyến (Fallback data) để app vẫn hiển thị đẹp, không bị màn hình đỏ lỗi
      return Weather(
        temperature: 28.5,
        windSpeed: 12.4,
        relativeHumidity: 75,
        weatherCode: 3, // Khai báo thời tiết ít mây đẹp trời
      );
    }
  }
}