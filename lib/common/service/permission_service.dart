import 'package:flexpace/common/common.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

class PermissionService {
  // 권한 요청 및 체크 로직
  static Future<bool> requestPermission(Permission permission) async {
    final status = await permission.status;
    if (!status.isGranted || status.isPermanentlyDenied) {
      final result = await permission.request();
      if (result.isDenied || result.isPermanentlyDenied) {
        // 권한 거절 시 처리
        _showPermissionPage(permission);
        return false;
      }
    }
    return true;
  }

  // 권한 거절 시 설정으로 유도하는 대화상자 표시
  static void _showPermissionPage(Permission permission) {
    String permissionName = _getPermissionName(permission);

    Get.showSnackbar(Common.getSnackBar('서비스 이용을 위해 ${permissionName}권한을 허용해주세요.'));

  }

// 권한 이름 반환
  static String _getPermissionName(Permission permission) {
    if (permission == Permission.camera) {
      return "카메라";
    } else if (permission == Permission.microphone) {
      return "마이크";
    } else if (permission == Permission.storage ||
        permission == Permission.photos) {
      return "사진";
    } else {
      return "기타";
    }
  }
}
