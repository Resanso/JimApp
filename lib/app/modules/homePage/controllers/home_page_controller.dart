import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jim/core/controllers/anatomy_controller.dart';

class HomePageController extends GetxController {
  final currentIndex = 0.obs;
  final anatomyController = Get.find<AnatomyController>();
  final userName = 'User'.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId) // Use userId as document ID
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        userName.value = userData['name'] ?? 'Guest';
      }
    } catch (e) {
      print('Error fetching user name: $e');
      userName.value = 'Guest';
    }
  }

  String getDisplayName() {
    return userName.value;
  }

  void changePage(int index) {
    currentIndex.value = index;
  }
}
