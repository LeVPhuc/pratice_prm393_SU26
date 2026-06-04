import 'package:flutter/material.dart';
import 'lab6/screens/genre_browsing_screen.dart'; // <-- ĐÂY LÀ DÒNG BẠN ĐANG THIẾU

void main() {
  runApp(const ResponsiveMovieApp());
}

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Movie Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const GenreBrowsingScreen(), // Hết gạch đỏ
    );
  }
}