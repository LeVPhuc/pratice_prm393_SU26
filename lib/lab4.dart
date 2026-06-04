import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false, // Ẩn dải băng DEBUG màu đỏ ở góc màn hình
  home: Ex5Screen(),
));

class Ex5Screen extends StatelessWidget {
  const Ex5Screen({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách 4 phim theo đúng mẫu của đề bài
    final List<String> debugMovies = ['Movie A', 'Movie B', 'Movie C', 'Movie D'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5 – Common U...'),
        leading: const Icon(Icons.arrow_back), // Thêm nút quay lại giống hệt ảnh mẫu
      ),
      // FIX 2: Bọc toàn bộ body bằng SingleChildScrollView chống tràn khung hình khi màn hình nhỏ
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Căn toàn bộ nội dung trong Column sát lề bên trái (Left-aligned)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề chuẩn 100% theo ảnh mẫu đề bài
            const Text(
              'Correct ListView inside Column using Expanded',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.3, // Giúp giãn dòng chữ tiêu đề khi bị xuống hàng
              ),
            ),
            const SizedBox(height: 24), // Tạo khoảng cách thông thoáng dưới tiêu đề

            // FIX 1: Giới hạn chiều cao hoặc bọc Expanded để ListView không làm sập Column
            SizedBox(
              height: 400, // Tăng chiều cao lên để hiển thị vừa vặn danh sách
              child: ListView.builder(
                // Bật lại tính năng cuộn mượt mà để bạn tương tác hoàn toàn với danh sách
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: debugMovies.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero, // Xóa khoảng đệm thừa sát lề
                      // Thêm Icon cuộn phim màu xám đậm phía trước giống ảnh mẫu
                      leading: const Icon(
                        Icons.movie_creation_rounded,
                        color: Color(0xFF4A4B4D),
                        size: 28,
                      ),
                      // Tên phim định dạng chữ vừa vặn, rõ ràng
                      title: Text(
                        debugMovies[index],
                        style: const TextStyle(fontSize: 16, color: Color(0xFF1C1B1F)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}