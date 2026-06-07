class Book {
  final String id;
  final String title;
  final String author;

  Book({required this.id, required this.title, required this.author});

  // Chuyển từ JSON (Map) sang Object Dart
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
    );
  }

  // Chuyển từ Object Dart sang Map để ghi vào file JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
    };
  }
}