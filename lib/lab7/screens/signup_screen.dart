import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Key quản lý trạng thái và xác thực Form
  final _formKey = GlobalKey<FormState>();

  // Các Bộ điều khiển dữ liệu ô nhập (Controllers)
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Các Nút quản lý con trỏ nhập liệu (FocusNodes) cho Lab 7.3
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _isLoading = false; // Trạng thái đợi khi giả lập check API
  bool _obscurePassword = true; // Biến ẩn/hiện mật khẩu

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi hủy màn hình để tránh rò rỉ bộ nhớ (Memory Leak)
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  // Lab 7.4: Giả lập kiểm tra trùng lặp Email bất đồng bộ (Fake Async API Call)
  Future<bool> _isEmailAlreadyTaken(String email) async {
    await Future.delayed(const Duration(milliseconds: 1500)); // Đợi 1.5 giây giả lập mạng
    // Nếu user nhập đúng email này thì coi như đã bị trùng trong hệ thống
    return email.toLowerCase() == "test@gmail.com";
  }

  // Hàm xử lý khi bấm nút Đăng ký (Submit Flow)
  void _submitForm() async {
    // 1. Kiểm tra xác thực các luật căn bản (Validate inline)
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // 2. Chạy kiểm tra bất đồng bộ (Async Validation)
      final emailTaken = await _isEmailAlreadyTaken(_emailController.text);

      setState(() {
        _isLoading = false;
      });

      if (emailTaken) {
        // Hiển thị thông báo lỗi màu đỏ nếu email đã tồn tại
        _showSnackBar("Email này đã được sử dụng. Vui lòng thử email khác!", Colors.red);
      } else {
        // Đăng ký thành công xuất sắc
        _showSnackBar("Đăng ký tài khoản thành công!", Colors.green);
        _formKey.currentState!.reset(); // Xóa sạch dữ liệu trên form sau khi thành công
      }
    }
  }

  // Hàm tiện ích hiển thị thanh thông báo (SnackBar) dưới đáy màn hình
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Lab 7.3 UX: Chạm vào bất kỳ vùng trống nào ngoài Form để tự động ẩn bàn phím ảo
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Account'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450), // Giới hạn chiều rộng trên nền Web nhìn cho đẹp
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey, // Gắn key quản lý trạng thái form vào đây
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Điền đầy đủ thông tin để tạo tài khoản mới',
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // 1. Trường nhập Full Name
                    TextFormField(
                      controller: _nameController,
                      focusNode: _nameFocus,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next, // Bàn phím hiện nút "Next"
                      onFieldSubmitted: (_) {
                        // Nhấn Next tự động di chuyển con trỏ nhảy sang ô Email
                        FocusScope.of(context).requestFocus(_emailFocus);
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập họ và tên của bạn';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 2. Trường nhập Email
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                        hintText: 'example@domain.com',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        // Nhấn Next tự động nhảy sang ô Password
                        FocusScope.of(context).requestFocus(_passwordFocus);
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập Email';
                        }
                        // Biểu thức chính quy (Regex) kiểm tra cấu trúc Email chuẩn
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Định dạng Email không hợp lệ (Thiếu @ hoặc đuôi tên miền)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 3. Trường nhập Password
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      obscureText: _obscurePassword, // Ẩn/hiện ký tự mật khẩu dạng dấu tròn
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        border: const OutlineInputBorder(),
                        // Nút bật/tắt mắt xem mật khẩu để tăng trải nghiệm UX
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        // Nhấn Next tự động nhảy sang ô xác nhận Confirm Password
                        FocusScope.of(context).requestFocus(_confirmPasswordFocus);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu';
                        }
                        if (value.length < 8) {
                          return 'Mật khẩu phải chứa ít nhất 8 ký tự';
                        }
                        if (!RegExp(r'[0-9]').hasMatch(value)) {
                          return 'Mật khẩu phải chứa ít nhất 1 chữ số (0-9)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 4. Trường nhập Confirm Password
                    TextFormField(
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocus,
                      obscureText: _obscurePassword,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock_clock_outlined),
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.done, // Ô cuối cùng hiện nút "Done" trên bàn phím ảo
                      onFieldSubmitted: (_) => _submitForm(), // Nhấn nút Done tự động thực thi gửi Form
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng xác nhận lại mật khẩu';
                        }
                        if (value != _passwordController.text) {
                          return 'Mật khẩu xác nhận không trùng khớp!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Nút bấm Đăng ký tích hợp vòng xoay Loading tiến trình
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom( // Đã sửa: dùng chữ s viết thường chuẩn xác
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                          : const Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}