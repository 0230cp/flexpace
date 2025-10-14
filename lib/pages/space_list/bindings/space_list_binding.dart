import 'package:flexpace/pages/space_list/controller/space_list_controller.dart';
import 'package:get/get.dart';

class SpaceListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SpaceListController());
  }
}
