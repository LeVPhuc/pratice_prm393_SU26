import 'dart:async';

void main() async {
  print('==================================================');
  print('   LAB 2 – DART ESSENTIALS PRACTICE LAB REPORT   ');
  print('==================================================\n');

  // --- EXERCISE 1: BASIC SYNTAX & DATA TYPES ---
  print('--- EXERCISE 1 – BASIC SYNTAX & DATA TYPES ---');
  int age = 21;
  double gpa = 3.85;
  String name = 'Nguyễn Văn A';
  bool isStudent = true;

  print('Họ tên: $name | GPA: $gpa');
  print('Tuổi vào năm tới: ${age + 1} - Sinh viên: ${isStudent ? "Có" : "Không"}\n');


  // --- EXERCISE 2: COLLECTIONS & OPERATORS ---
  print('--- EXERCISE 2 – COLLECTIONS & OPERATORS ---');
  // List, Set, Map & Toán tử
  var scores = [85, 90, 78];
  print('Tổng 2 điểm đầu: ${scores[0] + scores[1]} | Điểm đầu > cuối: ${scores[0] > scores[2]}');

  var tags = {'dart', 'flutter', 'dart'}; // Tự động loại bỏ phần tử 'dart' trùng lặp
  tags.add('mobile');
  print('Set thẻ tags: $tags');

  var product = {'name': 'Laptop ASUS', 'price': 1200.0, 'inStock': true};
  product['price'] = 1150.0; // Cập nhật giá trị qua Key

  bool canBuy = (product['price'] as double < 1500.0) && (product['inStock'] == true);
  print('Sản phẩm: ${product['name']} | Trạng thái mua: ${canBuy ? "Có thể mua" : "Không thể mua"}\n');


  // --- EXERCISE 3: CONTROL FLOW & FUNCTIONS ---
  print('--- EXERCISE 3 – CONTROL FLOW & FUNCTIONS ---');
  double myScore = 88.5;
  print('Kết quả học tập: ${myScore >= 50 ? "ĐẠT" : "TRƯỢT"}');

  int dayOfWeek = 3;
  switch (dayOfWeek) {
    case 1: print('Thứ Hai'); break;
    case 3: print('Thứ Tư (Giữa tuần)'); break;
    default: print('Ngày khác');
  }

  var fruits = ['Táo', 'Chuối', 'Cam'];
  print('Duyệt mảng bằng 3 cách:');
  for (var i = 0; i < fruits.length; i++) print('  - For truyền thống: ${fruits[i]}');
  for (var fruit in fruits) print('  - For-in: $fruit');
  fruits.forEach((fruit) => print('  - forEach: $fruit'));

  print('Tiền thưởng: \$${calculateBonus(myScore)} | Đánh giá: ${getReviewMessage(myScore)}\n');


  // --- EXERCISE 4: INTRO TO OOP ---
  print('--- EXERCISE 4 – INTRO TO OOP ---');
  var basicCar = Car('Toyota');
  var unknownCar = Car.anonymous();
  var myTesla = ElectricCar('Tesla Model Y', 75);

  basicCar.drive();
  unknownCar.drive();
  myTesla.drive(); // Chạy hàm đã được ghi đè (Override)
  print('');


  // --- EXERCISE 5: ASYNC, FUTURE, NULL SAFETY & STREAMS ---
  print('--- EXERCISE 5 – ASYNC, FUTURE, NULL SAFETY & STREAMS ---');
  String? nullableName;
  print('Tên hiển thị (Toán tử ??): ${nullableName ?? "Khách vãng lai"}');
  nullableName = 'Trần Văn B';
  print('Độ dài tên (Toán tử !): ${nullableName!.length}');

  print('\nĐang tải dữ liệu từ server...');
  var result = await fetchNetworkData(); // Chờ 2 giây (Future)
  print('Kết quả Future: $result');

  print('\nBắt đầu lắng nghe dòng dữ liệu (Stream):');
  await for (var second in countSeconds(3)) { // Duyệt qua từng giây của Stream
    print('  -> Giây thứ: $second');
  }

  print('\n==================================================');
  print('        HOÀN THÀNH TOÀN BỘ BÀI THỰC HÀNH LAB 2     ');
  print('==================================================');
}

// ============================================================================
// CÁC HÀM VÀ LỚP BỔ TRỢ (ĐƯỢC ĐẶT NGOÀI HÀM MAIN)
// ============================================================================

// Hàm bài 3: Viết theo dạng Normal Syntax (Viết sạch - bỏ else thừa)
double calculateBonus(double score) {
  if (score >= 90) return 500.0;
  if (score >= 75) return 200.0;
  return 0.0;
}

// Hàm bài 3: Viết theo dạng Arrow Syntax
String getReviewMessage(double score) => score >= 80 ? 'Xuất sắc' : 'Cần cố gắng';

// Class Bài 4: Lớp Cha
class Car {
  String brand;
  Car(this.brand);
  Car.anonymous() : brand = 'Hãng xe ẩn danh';

  void drive() => print('$brand đang chạy bằng động cơ xăng.');
}

// Class Bài 4: Lớp Con kế thừa từ lớp Cha
class ElectricCar extends Car {
  int batteryCapacity;
  ElectricCar(super.brand, this.batteryCapacity); // Cú pháp super short-hand mới

  @override
  void drive() => print('$brand đang chạy bằng điện. Pin: $batteryCapacity kWh.');
}

// Hàm bài 5: Giả lập tải mạng bằng Future
Future<String> fetchNetworkData() =>
    Future.delayed(const Duration(seconds: 2), () => 'Tải dữ liệu thành công!');

// Hàm bài 5: Tạo dòng dữ liệu đếm giây bằng Stream
Stream<int> countSeconds(int maxSeconds) async* {
  for (var i = 1; i <= maxSeconds; i++) {
    await Future.delayed(const Duration(seconds: 1));
    yield i;
  }
}