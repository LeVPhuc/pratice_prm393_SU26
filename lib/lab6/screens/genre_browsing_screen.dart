import 'package:flutter/material.dart';
import '../models/movie_lab6.dart';

class GenreBrowsingScreen extends StatefulWidget {
  const GenreBrowsingScreen({super.key});

  @override
  State<GenreBrowsingScreen> createState() => _GenreBrowsingScreenState();
}

class _GenreBrowsingScreenState extends State<GenreBrowsingScreen> {
  // Các biến quản lý trạng thái Bộ lọc
  String _searchQuery = '';
  String _selectedGenre = 'All';
  String _sortBy = 'A–Z';

  // Danh sách các Thể loại phim hiển thị trên thanh chọn nhanh
  final List<String> _genres = ['All', 'Action', 'Animation', 'Sci-Fi', 'Comedy'];

  @override
  Widget build(BuildContext context) {
    // 1. Đọc kích thước màn hình bằng MediaQuery để xử lý Responsive
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTabletOrWeb = screenWidth >= 800;

    // 2. LOGIC BỘ LỌC VÀ SẮP XẾP PHIM
    List<MovieLab6> filteredMovies = sampleMoviesLab6.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesGenre = _selectedGenre == 'All' || movie.genre == _selectedGenre;
      return matchesSearch && matchesGenre;
    }).toList();

    // Thực hiện sắp xếp danh sách sau khi đã lọc
    if (_sortBy == 'A–Z') {
      filteredMovies.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortBy == 'Z–A') {
      filteredMovies.sort((a, b) => b.title.compareTo(a.title));
    } else if (_sortBy == 'Year') {
      filteredMovies.sort((a, b) => b.year.compareTo(a.year)); // Năm mới nhất lên đầu
    } else if (_sortBy == 'Rating') {
      filteredMovies.sort((a, b) => b.rating.compareTo(a.rating)); // Điểm cao nhất lên đầu
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Movie'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lab 6.1: Thanh Tìm Kiếm (Search Bar)
            TextField(
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 20),

            // Lab 6.2: Thanh Thể Loại Dạng Chips (Genre Chips)
            const Text('Genres', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _genres.map((genre) {
                final isSelected = _selectedGenre == genre;
                return FilterChip(
                  label: Text(genre),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedGenre = selected ? genre : 'All';
                    });
                  },
                  selectedColor: Colors.deepPurple.withOpacity(0.2),
                  checkmarkColor: Colors.deepPurple,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Thanh điều khiển Chọn kiểu Sắp xếp (Sort Dropdown)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Results (${filteredMovies.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Text('Sort by: '),
                    DropdownButton<String>(
                      value: _sortBy,
                      items: <String>['A–Z', 'Z–A', 'Year', 'Rating'].map((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value));
                      }).toList(),
                      onChanged: (newValue) => setState(() => _sortBy = newValue!),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Lab 6.3: Thiết kế Danh Sách Phim có tính năng RESPONSIVE
            // Dựa vào biến `isTabletOrWeb` để quyết định hiển thị dạng Dọc (Phone) hay Lưới (Tablet/Web)
            isTabletOrWeb
                ? GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredMovies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Chia làm 2 cột đối với màn hình rộng >= 800px
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3.2, // Tỷ lệ khung hình của thẻ phim nằm ngang
              ),
              itemBuilder: (context, index) => _buildMovieCard(filteredMovies[index]),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredMovies.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildMovieCard(filteredMovies[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget dùng chung để vẽ Thẻ Phim (Movie Card) gọn gàng sạch sẽ
  Widget _buildMovieCard(MovieLab6 movie) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                movie.posterUrl,
                width: 70,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const Icon(Icons.movie, size: 50),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(movie.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('Genre: ${movie.genre}', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  Text('Year: ${movie.year}', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text('${movie.rating}/10', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}