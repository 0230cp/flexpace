import 'package:flexpace/pages/change_nickname/controller/notice_controller.dart';
import 'package:get/get.dart';

class ChangeNickNameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangeNickNameController());
  }
}
