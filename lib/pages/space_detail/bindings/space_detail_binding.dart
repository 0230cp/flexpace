import 'package:flexpace/pages/space_detail/controller/space_detail_controller.dart';
import 'package:get/get.dart';

class SpaceDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SpaceDetailController());
  }
}
