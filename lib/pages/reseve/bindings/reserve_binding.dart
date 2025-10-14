import 'package:get/get.dart';

import '../controller/reserve_controller.dart';

class ReserveBinding extends Bindings {
  
  
  @override
  void dependencies() {
    Get.lazyPut(() => ReserveController());
  }
}
