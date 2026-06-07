import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    super.initState();
    // Khởi tạo gọi dữ liệu API thời tiết ngay khi mở màn hình
    _weatherFuture = _weatherService.fetchCurrentWeather();
  }

  // Hàm giúp làm tươi/tải lại dữ liệu từ API khi nhấn nút Sync
  void _refreshWeather() {
    setState(() {
      _weatherFuture = _weatherService.fetchCurrentWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hanoi Weather Companion'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _refreshWeather,
          )
        ],
      ),
      body: FutureBuilder<Weather>(
        future: _weatherFuture,
        builder: (context, snapshot) {
          // TRẠNG THÁI 1: Ứng dụng đang tải dữ liệu kết nối mạng (Loading)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang cập nhật thời tiết thời gian thực...'),
                ],
              ),
            );
          }

          // TRẠNG THÁI 2: Xảy ra lỗi mất kết nối mạng hoặc sai URL (Error)
          else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off, color: Colors.red, size: 70),
                    const SizedBox(height: 16),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshWeather,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }

          // TRẠNG THÁI 3: Kết nối API lấy dữ liệu thành công (Success Data)
          else if (snapshot.hasData) {
            final weather = snapshot.data!;
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 450), // Giới hạn chiều rộng giao diện trên Web
                  child: Column(
                    children: [
                      // Card 1: Hiển thị các chỉ số thời tiết cơ bản nhận từ API
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        color: Colors.blue.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              const Icon(Icons.wb_cloudy_outlined, size: 64, color: Colors.blue),
                              const SizedBox(height: 12),
                              Text(
                                '${weather.temperature}°C',
                                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                              ),
                              Text(
                                weather.getWeatherDescription(),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              const Divider(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildWeatherDetailItem(Icons.water_drop, '${weather.relativeHumidity}%', 'Độ ẩm'),
                                  _buildWeatherDetailItem(Icons.air, '${weather.windSpeed} km/h', 'Tốc độ gió'),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Card 2: PHẦN SÁNG TẠO ĐÁP ỨNG ĐỀ BÀI - LỜI KHUYÊN THỰC TẾ (Purpose-driven Element)
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        color: Colors.amber.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.lightbulb, color: Colors.amber, size: 28),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Lời khuyên cho bạn:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: colorsAmberScale, // Đã sửa: dùng chữ c viết thường chuẩn xác
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                weather.getRecommendation(),
                                style: const TextStyle(fontSize: 15, height: 1.4, fontWeight: FontWeight.w500, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: Text('Không tìm thấy dữ liệu'));
        },
      ),
    );
  }

  // Widget con hỗ trợ vẽ nhanh các chỉ số phụ (Độ ẩm, Tốc độ gió)
  Widget _buildWeatherDetailItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueGrey),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

// Biến màu tự chế dùng riêng cho tiêu đề ô lời khuyên
const colorsAmberScale = Color(0xFFB78103);