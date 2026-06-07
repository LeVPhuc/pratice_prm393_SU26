import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'dart:html' as html if (dart.library.io) 'dart:io';

class StorageHelper {
// Hàm lưu dữ liệu đa nền tảng
static Future<void> saveBooks(String jsonString) async {
if (kIsWeb) {
html.window.localStorage['books_database'] = jsonString;
} else {
final directory = await getApplicationDocumentsDirectory();
final file = File('${directory.path}/books_database.json');
await file.writeAsString(jsonString);
}
}

// Hàm tải dữ liệu đa nền tảng
static Future<String?> loadBooks() async {
if (kIsWeb) {
return html.window.localStorage['books_database'];
} else {
final directory = await getApplicationDocumentsDirectory();
final file = File('${directory.path}/books_database.json');
if (await file.exists()) {
return await file.readAsString();
}
}
return null;
}
}