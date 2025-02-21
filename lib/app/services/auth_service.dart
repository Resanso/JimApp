import 'package:hive_flutter/hive_flutter.dart';

/// Service untuk menangani autentikasi pengguna menggunakan Hive sebagai local storage
class AuthService {
  /// Nama box yang digunakan untuk menyimpan data autentikasi
  static const String authBox = 'authBox';

  /// Key untuk menyimpan ID pengguna dalam box
  static const String userIdKey = 'userId';

  /// Inisialisasi Hive dan membuka box autentikasi
  ///
  /// Method ini harus dipanggil sebelum menggunakan fungsi AuthService lainnya
  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox(authBox);
  }

  /// Menyimpan status login pengguna dengan menyimpan userId ke local storage
  ///
  /// [userId] adalah ID unik pengguna yang akan disimpan
  static Future<void> saveLoginStatus(String userId) async {
    final box = Hive.box(authBox);
    await box.put(userIdKey, userId);
  }

  /// Menghapus status login pengguna dari local storage
  ///
  /// Digunakan saat pengguna melakukan logout
  static Future<void> clearLoginStatus() async {
    final box = Hive.box(authBox);
    await box.delete(userIdKey);
  }

  /// Mengambil ID pengguna yang tersimpan
  ///
  /// Mengembalikan null jika pengguna belum login
  static String? getUserId() {
    final box = Hive.box(authBox);
    return box.get(userIdKey);
  }

  /// Memeriksa apakah pengguna sudah login
  ///
  /// Mengembalikan true jika userId tersimpan, false jika tidak
  static bool isLoggedIn() {
    return getUserId() != null;
  }
}
