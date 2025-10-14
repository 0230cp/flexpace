import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class SpaceDetailController extends GetxController {
  CarouselSliderController carouselController = CarouselSliderController();

  RxInt carouselSliderIndex = 0.obs;

  RxMap spaceDetail = {}.obs;

  contact(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      return;
    }

    launchUrl(Uri(
      scheme: 'tel',
      path: phoneNumber,
    ));
  }

  @override
  void onInit() {
    spaceDetail.value = Get.arguments;

    Logger().e(spaceDetail);
    super.onInit();
  }
}
