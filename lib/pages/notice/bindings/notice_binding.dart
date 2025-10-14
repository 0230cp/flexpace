import 'package:flexpace/pages/notice/controller/notice_controller.dart';
import 'package:flexpace/pages/sign_in/controller/sign_in_controller.dart';
import 'package:get/get.dart';

class NoticeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NoticeController());
  }
}
