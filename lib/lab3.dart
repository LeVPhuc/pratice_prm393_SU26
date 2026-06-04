import 'dart:async';
import 'dart:convert';

void main() async {
  print('==================================================');
  print('      BÀI TẬP THỰC HÀNH TỔNG HỢP LAB 3 - DART     ');
  print('==================================================\n');

  await runExercise1();
  runExercise2();
  runExercise3(); // Chạy Event Loop độc lập
  await runExercise4();
  runExercise5();

  print('\n==================================================');
}

// ============================================================================
// EXERCISE 1: PRODUCT MODEL & REPOSITORY (Future & Stream)
// ============================================================================
Future<void> runExercise1() async {
  print('--- EXERCISE 1 ---');
  var controller = StreamController<Product>();

  // Lắng nghe dữ liệu thời gian thực (Stream)
  controller.stream.listen((p) => print('  [Stream nhận]: ${p.name} - \$${p.price}'));

  // Giả lập lấy danh sách dữ liệu tĩnh (Future)
  Future<List<Product>> getAll() async => [Product('iPhone 15', 999)];
  var list = await getAll();
  print('  [Future lấy về]: ${list[0].name}');

  // Đẩy một sản phẩm mới vào luồng Stream
  controller.add(Product('iPad Pro', 799));

  await Future.delayed(const Duration(milliseconds: 100)); // Chờ in kết quả
  controller.close();
}

// ============================================================================
// EXERCISE 2: USER REPOSITORY WITH JSON (Parse JSON thành Class)
// ============================================================================
void runExercise2() {
  print('\n--- EXERCISE 2 ---');
  String rawJson = '[{"name": "Nguyen Van A", "email": "a@gmail.com"}]';

  // Chuyển đổi chuỗi JSON thô thành đối tượng Class User trên 1 dòng
  List<User> users = (jsonDecode(rawJson) as List).map((x) => User.fromJson(x)).toList();

  print('  User đã định dạng: ${users[0].name} | ${users[0].email}');
}

// ============================================================================
// EXERCISE 3: ASYNC + MICROTASK DEBUGGING (Thứ tự Event Loop)
// ============================================================================
void runExercise3() {
  print('\n--- EXERCISE 3 ---');
  print('  1. Đồng bộ chạy ĐẦU TIÊN');

  // Nằm trong Event Queue (Chạy sau cùng)
  Future(() => print('  4. Future chạy CUỐI CÙNG'));

  // Nằm trong Microtask Queue (Ưu tiên chạy trước Future)
  scheduleMicrotask(() => print('  3. Microtask chạy THỨ BA'));

  print('  2. Đồng bộ chạy THỨ HAI');
}

// ============================================================================
// EXERCISE 4: STREAM TRANSFORMATION (Biến đổi luồng dữ liệu)
// ============================================================================
Future<void> runExercise4() async {
  // Trì hoãn 1 giây để bài tập số 3 in ra hết kết quả dưới Console, tránh bị ghi đè chữ
  await Future.delayed(const Duration(seconds: 1));
  print('\n--- EXERCISE 4 ---');

  // Tạo nguồn số 1-5, bình phương lên (map), lọc lấy số chẵn (where)
  var myStream = Stream.fromIterable([1, 2, 3, 4, 5])
      .map((n) => n * n)
      .where((n) => n.isEven);

  print('  Kết quả lọc số chẵn sau khi bình phương:');
  await for (var num in myStream) {
    print('    -> Nhận số: $num');
  }
}

// ============================================================================
// EXERCISE 5: FACTORY CONSTRUCTORS & CACHE (Mẫu Singleton)
// ============================================================================
void runExercise5() {
  print('\n--- EXERCISE 5 ---');
  var s1 = Settings(theme: 'Light');
  var s2 = Settings(theme: 'Dark'); // Sẽ bị bộ đệm (cache) từ chối đổi sang Dark

  print('  Theme s1: ${s1.theme} | Theme s2: ${s2.theme}');
  print('  Hai thực thể trỏ chung vào 1 ô nhớ RAM? -> ${identical(s1, s2)}');
}


// Định nghĩa cho Bài 1
class Product {
  final String name; final double price;
  Product(this.name, this.price);
}

// Định nghĩa cho Bài 2
class User {
  final String name, email;
  User.fromJson(Map<String, dynamic> json) : name = json['name'], email = json['email'];
}

// Định nghĩa cho Bài 5 (Áp dụng bộ nhớ đệm Cache Pattern)
class Settings {
  final String theme;
  static Settings? _cache; // Biến static lưu bộ nhớ đệm dùng chung

  Settings._internal(this.theme); // Hàm khởi tạo ẩn (Private)

  factory Settings({required String theme}) {
    _cache ??= Settings._internal(theme); // Nếu cache trống thì tạo mới, có rồi thì dùng lại
    return _cache!; // Luôn trả về ô nhớ duy nhất
  }
}