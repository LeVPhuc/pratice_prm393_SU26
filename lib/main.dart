// import 'package:flutter/material.dart';
// import 'lab6/screens/genre_browsing_screen.dart'; // <-- ĐÂY LÀ DÒNG BẠN ĐANG THIẾU
//
// void main() {
//   runApp(const ResponsiveMovieApp());
// }
//
// class ResponsiveMovieApp extends StatelessWidget {
//   const ResponsiveMovieApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Responsive Movie Browser',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const GenreBrowsingScreen(), // Hết gạch đỏ
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'lab7/screens/signup_screen.dart'; // Import đúng đường dẫn bài Lab 7
//
// void main() {
//   runApp(const FormValidationApp());
// }
//
// class FormValidationApp extends StatelessWidget {
//   const FormValidationApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Signup Form Validation',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const SignupScreen(), // Gọi màn hình đăng ký Lab 7 làm trang chủ
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'lab8/screens/post_list_screen.dart'; // Import đúng đường dẫn bài Lab 8
//
// void main() {
//   runApp(const ApiPoweredApp());
// }
//
// class ApiPoweredApp extends StatelessWidget {
//   const ApiPoweredApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'API Powered List App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const PostListScreen(), // Đặt màn hình danh sách API làm trang chủ
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'lab8b/screens/weather_screen.dart'; // Import đúng bài Lab 8B
//
// void main() {
//   runApp(const WeatherCompanionApp());
// }
//
// class WeatherCompanionApp extends StatelessWidget {
//   const WeatherCompanionApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Weather Companion',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//       ),
//       home: const WeatherScreen(), // Gọi màn hình thời tiết thông minh
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'lab9/screens/book_crud_screen.dart'; // Import đúng đường dẫn bài Lab 9
//
// void main() {
//   runApp(const LocalStorageApp());
// }
//
// class LocalStorageApp extends StatelessWidget {
//   const LocalStorageApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Local JSON Storage CRUD',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const BookCrudScreen(), // Khởi động trang quản lý cơ sở dữ liệu sách JSON
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'lab10/screens/splash_screen.dart'; // Import đúng bài Lab 10

void main() {
  runApp(const AuthenticationApp());
}

class AuthenticationApp extends StatelessWidget {
  const AuthenticationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10 Authentication App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(), // Màn hình Splash chạy đầu tiên để kiểm tra Auto-login
    );
  }
}