import 'package:flexpace/common/service/userdata_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class GlobalAppbarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const GlobalAppbarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: SvgPicture.asset('assets/icon/title.svg'),
        leading: InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Center(child: SvgPicture.asset('assets/icon/menu.svg'))),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: InkWell(
                onTap: (){
                  if(UserDataService.to.userData.value.docId != null){
                    Get.toNamed('/reserve');
                  }else{
                  Get.toNamed('/sign_in');
                }},
                child: SvgPicture.asset('assets/icon/record.svg')),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
