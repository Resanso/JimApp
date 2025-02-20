import 'package:get/get.dart';
import '../controllers/home_page_controller.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    // Remove AnatomyController initialization since it's done in main.dart
    Get.lazyPut<HomePageController>(() => HomePageController());
  }
}
