import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jim/core/controllers/anatomy_controller.dart';

/// Controller untuk mengelola logika halaman utama (HomePage)
///
/// Controller ini menangani navigasi bottom bar dan informasi user
class HomePageController extends GetxController {
  /// Index halaman yang sedang aktif
  final currentIndex = 0.obs;

  /// Instance dari AnatomyController untuk mengakses data anatomi
  final anatomyController = Get.find<AnatomyController>();

  /// Nama pengguna yang sedang login
  final userName = 'User'.obs;

  /// Dipanggil saat controller diinisialisasi
  /// Mengambil data nama user dari Firestore
  @override
  void onInit() {
    super.onInit();
    _fetchUserName();
  }

  /// Mengambil nama pengguna dari Firestore
  ///
  /// Method ini akan:
  /// 1. Mengambil ID user yang sedang login
  /// 2. Mengambil dokumen user dari collection 'users'
  /// 3. Mengupdate [userName] dengan nama yang didapat
  /// 4. Jika terjadi error, nama default 'Guest' akan digunakan
  Future<void> _fetchUserName() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        userName.value = userData['name'] ?? 'Guest';
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching user name: $e');
      userName.value = 'Guest';
    }
  }

  /// Mendapatkan nama pengguna yang akan ditampilkan
  ///
  /// Returns:
  ///   String nama pengguna yang tersimpan di [userName]
  String getDisplayName() {
    return userName.value;
  }

  /// Mengubah halaman yang aktif
  ///
  /// Parameter:
  ///   index - Index halaman yang akan ditampilkan
  void changePage(int index) {
    currentIndex.value = index;
  }
}
