import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../book_model.dart';
import '../storage_helper.dart';

class BookCrudScreen extends StatefulWidget {
  const BookCrudScreen({super.key});

  @override
  State<BookCrudScreen> createState() => _BookCrudScreenState();
}

class _BookCrudScreenState extends State<BookCrudScreen> {
  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  bool _isLoading = true;

  final _searchController = TextEditingController();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterBooks);
  }

  // Hàm tải dữ liệu từ Assets hoặc Local Storage (Lab 9.1 & 9.2)
  Future<void> _loadData() async {
    try {
      final String? localData = await StorageHelper.loadBooks();

      if (localData != null && localData.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(localData);
        setState(() {
          _books = jsonList.map((json) => Book.fromJson(json)).toList();
          _filteredBooks = _books;
          _isLoading = false;
        });
      } else {
        final String assetsContent = await rootBundle.loadString('assets/initial_books.json');
        final List<dynamic> jsonList = jsonDecode(assetsContent);

        setState(() {
          _books = jsonList.map((json) => Book.fromJson(json)).toList();
          _filteredBooks = _books;
          _isLoading = false;
        });
        await _saveData();
      }
    } catch (e) {
      _showSnackBar('Lỗi khi tải dữ liệu: $e', Colors.red);
    }
  }

  // Hàm lưu dữ liệu tự động (Lab 9.2 & Auto-save cho Lab 9.3)
  Future<void> _saveData() async {
    try {
      final String jsonString = jsonEncode(_books.map((b) => b.toJson()).toList());
      await StorageHelper.saveBooks(jsonString);
    } catch (e) {
      _showSnackBar('Lỗi khi lưu dữ liệu: $e', Colors.red);
    }
  }

  // Bộ lọc tìm kiếm sách (Lab 9.3)
  void _filterBooks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBooks = _books.where((book) {
        return book.title.toLowerCase().contains(query) ||
            book.author.toLowerCase().contains(query);
      }).toList();
    });
  }

  // Hộp thoại thêm mới hoặc chỉnh sửa thông tin sách (Lab 9.3 CRUD)
  void _openBookDialog({Book? book}) {
    if (book != null) {
      _titleController.text = book.title;
      _authorController.text = book.author;
    } else {
      _titleController.clear();
      _authorController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(book == null ? 'Thêm Sách Mới' : 'Sửa Thông Tin Sách'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Tên đầu sách'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Tác giả'),
            ),
          ],
        ),
        actions: [ // ĐÃ SỬA từ 'options' thành 'actions' chuẩn Flutter
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.trim().isEmpty || _authorController.text.trim().isEmpty) {
                _showSnackBar('Vui lòng điền đầy đủ thông tin!', Colors.orange);
                return;
              }

              // ĐÃ SỬA: Chỉ giữ logic đồng bộ cập nhật list vào trong setState
              setState(() {
                if (book == null) {
                  final newBook = Book(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: _titleController.text.trim(),
                    author: _authorController.text.trim(),
                  );
                  _books.add(newBook);
                  _showSnackBar('Đã thêm sách mới thành công!', Colors.green);
                } else {
                  final index = _books.indexWhere((b) => b.id == book.id);
                  if (index != -1) {
                    _books[index] = Book(
                      id: book.id,
                      title: _titleController.text.trim(),
                      author: _authorController.text.trim(),
                    );
                    _showSnackBar('Đã cập nhật thông tin sách!', Colors.blue);
                  }
                }
              });

              // ĐÃ SỬA: Đẩy các hàm bổ trợ ra bên ngoài hoàn toàn độc lập với setState
              _filterBooks();
              _saveData();
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  // Hộp thoại xác nhận xóa sách khỏi bộ nhớ (D trong CRUD)
  void _deleteBook(Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa cuốn sách "${book.title}" này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              setState(() {
                _books.removeWhere((b) => b.id == book.id);
              });
              _filterBooks();
              _saveData();
              _showSnackBar('Đã xóa sách khỏi bộ nhớ cục bộ.', Colors.grey.shade700);
              Navigator.pop(context);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON Local Database (Lab 9)'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
          children: [
      Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm theo tên sách hoặc tác giả...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => _searchController.clear(),
          )
              : null,
        ),
        ],
      ),
      Expanded(
        child: _filteredBooks.isEmpty
            ? const Center(child: Text('Không tìm thấy cuốn sách nào.'))
            : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: _filteredBooks.length,
          itemBuilder: (context, index) {
            final book = _filteredBooks[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple.withOpacity(0.1),
                  child: const Icon(Icons.book, color: Colors.deepPurple),
                ),
                title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Text('Tác giả: ${book.author}', style: TextStyle(color: Colors.grey.shade600)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _openBookDialog(book: book),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteBook(book),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
    onPressed: () => _openBookDialog(),
    backgroundColor: Colors.deepPurple,
    foregroundColor: Colors.white,
    child: const Icon(Icons.add),
    ),
    );
    }

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }
}