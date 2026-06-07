import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _name = 'User';
  String _avatarUrl = '';
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Đọc profile user từ Session SharedPreferences lên giao diện (Lab 10.3)
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('user_name') ?? 'User';
      _avatarUrl = prefs.getString('user_avatar') ?? '';
    });
  }

  void _handleLogout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Màn Hình Chính'),
        actions: [
          IconButton(icon: const Icon(Icons.logout_rounded, color: Colors.red), onPressed: _handleLogout)
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _avatarUrl.isNotEmpty
                  ? ClipRRect(borderRadius: BorderRadius.circular(50), child: Image.network(_avatarUrl, height: 100, width: 100, fit: BoxFit.cover))
                  : const Icon(Icons.account_circle, size: 100, color: Colors.grey),
              const SizedBox(height: 16),
              Text('Chào mừng quay trở lại,', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
              const SizedBox(height: 8),
              Text(_name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              const SizedBox(height: 32),
              Card(
                color: Colors.green.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 12),
                      Text('Phiên làm việc (Session) đã được lưu cục bộ!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}