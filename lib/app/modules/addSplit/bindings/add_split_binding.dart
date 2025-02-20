import 'package:get/get.dart';

import '../controllers/add_split_controller.dart';

class AddSplitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddSplitController>(
      () => AddSplitController(),
    );
  }
}
