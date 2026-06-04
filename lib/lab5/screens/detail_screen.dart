import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Quay về màn hình danh sách
        ),
      ),
      body: Center(
        // SỬA LỖI 1: Giới hạn chiều ngang tối đa 500px để giao diện Web không bị bè ra
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SỬA LỖI 2: Tạo Hero Banner dùng Stack bọc Ảnh + Lớp phủ Gradient đen
                Stack(
                  children: [
                    Image.network(
                      movie.posterUrl,
                      width: double.infinity,
                      height: 350,
                      fit: BoxFit.cover, // Ảnh phủ kín vùng không bị móp
                    ),
                    // Lớp màu Gradient đổ từ trong suốt sang đen ở đáy ảnh
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Tên phim chữ trắng nằm đè lên lớp Gradient ở góc dưới
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hiển thị các nhãn Thể loại phim (Chips)
                      Wrap(
                        spacing: 8,
                        children: movie.genres.map((genre) {
                          return Chip(
                            label: Text(genre),
                            backgroundColor: Colors.deepPurple.withOpacity(0.1),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Hàng nút tương tác (Yêu thích, Điểm số, Chia sẻ)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: _isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () => setState(() => _isFavorite = !_isFavorite),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text('${movie.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.blue),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Phần tóm tắt nội dung phim
                      const Text('Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(movie.overview, style: const TextStyle(fontSize: 15, height: 1.4)),
                      const SizedBox(height: 24),

                      // Danh sách Trailers
                      const Text('Trailers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: movie.trailers.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.play_circle_outline, color: Colors.red, size: 28),
                            title: Text(movie.trailers[index]),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}