class Weather {
  final double temperature;
  final double windSpeed;
  final int relativeHumidity;
  final int weatherCode;

  Weather({
    required this.temperature,
    required this.windSpeed,
    required this.relativeHumidity,
    required this.weatherCode,
  });

  // Hàm factory chuyển đổi JSON từ Open-Meteo API sang Object Dart
  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    return Weather(
      temperature: (current['temperature_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      relativeHumidity: (current['relative_humidity_2m'] as num).toInt(),
      weatherCode: (current['weather_code'] as num).toInt(),
    );
  }

  // Hàm thông minh (Purpose-driven element): Tự động đưa ra lời khuyên dựa trên chỉ số API
  String getRecommendation() {
    if (weatherCode >= 51) {
      return "Trời đang có mưa hoặc bão. Hãy mang theo ô (dù) và mặc áo mưa khi ra đường nhé! ☔";
    } else if (temperature > 32) {
      return "Thời tiết khá nắng nóng. Hãy bôi kem chống nắng và mang theo nước uống đầy đủ! ☀️";
    } else if (temperature < 18) {
      return "Trời se lạnh rồi. Nhớ khoác thêm một chiếc áo ấm trước khi ra ngoài bạn nhé! 🧥";
    } else {
      return "Thời tiết hôm nay tuyệt vời! Rất thích hợp cho các hoạt động ngoài trời hoặc chạy bộ. 🏃‍♂️🍃";
    }
  }

  // Hàm lấy mô tả thời tiết bằng chữ dựa trên mã hiệu Weather Code
  String getWeatherDescription() {
    if (weatherCode == 0) return "Trời quang mây";
    if (weatherCode >= 1 && weatherCode <= 3) return "Ít mây / Mây rải rác";
    if (weatherCode >= 45 && weatherCode <= 48) return "Có sương mù";
    if (weatherCode >= 51 && weatherCode <= 67) return "Trời có mưa";
    if (weatherCode >= 71 && weatherCode <= 77) return "Có tuyết rơi";
    if (weatherCode >= 80 && weatherCode <= 82) return "Mưa rào lớn";
    if (weatherCode >= 95) return "Có dông bão";
    return "Thời tiết bình thường";
  }
}