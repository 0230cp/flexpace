import 'package:flexpace/pages/change_nickname/bindings/notice_binding.dart';
import 'package:flexpace/pages/change_nickname/view/notice_view_page.dart';
import 'package:flexpace/pages/main/bindings/main_binding.dart';
import 'package:flexpace/pages/main/view/main_view_page.dart';
import 'package:flexpace/pages/notice/bindings/notice_binding.dart';
import 'package:flexpace/pages/notice/view/notice_view_page.dart';
import 'package:flexpace/pages/notice_detail/bindings/notice_detail_binding.dart';
import 'package:flexpace/pages/notice_detail/view/notice_detail_view_page.dart';
import 'package:flexpace/pages/profile/bindings/profile_binding.dart';
import 'package:flexpace/pages/profile/view/profile_view_page.dart';
import 'package:flexpace/pages/reservation/bindings/reservation_binding.dart';
import 'package:flexpace/pages/reservation/view/reservation_view_page.dart';
import 'package:flexpace/pages/reseve/bindings/reserve_binding.dart';
import 'package:flexpace/pages/reseve/view/reserve_view_page.dart';
import 'package:flexpace/pages/sign_in/bindings/sign_in_binding.dart';
import 'package:flexpace/pages/sign_in/view/sign_in_view_page.dart';
import 'package:flexpace/pages/social_sign_up/bindings/social_sign_up_binding.dart';
import 'package:flexpace/pages/social_sign_up/view/social_sign_up_view_page.dart';
import 'package:flexpace/pages/space_detail/bindings/space_detail_binding.dart';
import 'package:flexpace/pages/space_detail/view/space_detail_view_page.dart';
import 'package:flexpace/pages/space_list/bindings/space_list_binding.dart';
import 'package:flexpace/pages/space_list/view/space_list_view_page.dart';
import 'package:flexpace/pages/terms/bindings/terms_binding.dart';
import 'package:flexpace/pages/terms/view/terms_view_page.dart';
import 'package:get/get.dart';

import '../pages/splash/bindings/splash_binding.dart';
import '../pages/splash/view/splash_view_page.dart';

class GetXRouter {
  static final route = [
    GetPage(
        name: '/',
        page: () => const SplashViewPage(),
        binding: SplashBinding(),
        popGesture: true),
    GetPage(
        name: '/sign_in',
        page: () => const SignInViewPage(),
        binding: SignInBinding(),
        popGesture: true),
    GetPage(
        name: '/social_sign_up',
        page: () => const SocialSignUpViewPage(),
        binding: SocialSignUpBinding(),
        popGesture: true),
    GetPage(
        name: '/main',
        page: () => const MainViewPage(),
        binding: MainBinding(),
        popGesture: true),
    GetPage(
        name: '/reserve',
        page: () => const ReserveViewPage(),
        binding: ReserveBinding(),
        popGesture: true),
    GetPage(
        name: '/profile',
        page: () => const ProfileViewPage(),
        binding: ProfileBinding(),
        popGesture: true),
    GetPage(
        name: '/change_nickname',
        page: () => const ChangeNickNameViewPage(),
        binding: ChangeNickNameBinding(),
        popGesture: true),
    GetPage(
        name: '/space_list',
        page: () => const SpaceListViewPage(),
        binding: SpaceListBinding(),
        popGesture: true),
    GetPage(
        name: '/space_detail',
        page: () => const SpaceDetailViewPage(),
        binding: SpaceDetailBinding(),
        popGesture: true),
    GetPage(
        name: '/reservation',
        page: () => const ReservationViewPage(),
        binding: ReservationBinding(),
        popGesture: true),
    GetPage(
        name: '/notice',
        page: () => const NoticeViewPage(),
        binding: NoticeBinding(),
        popGesture: true),
    GetPage(
        name: '/notice_detail',
        page: () => const NoticeDetailViewPage(),
        binding: NoticeDetailBinding(),
        popGesture: true),
    GetPage(
        name: '/terms',
        page: () => const TermsViewPage(),
        binding: TermsBinding(),
        popGesture: true),
  ];
}
