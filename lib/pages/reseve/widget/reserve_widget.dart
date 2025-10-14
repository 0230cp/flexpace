import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ReservationListWidget extends StatelessWidget {
  const ReservationListWidget({
    super.key,
    required this.reserveList, required this.onTap, required this.isReverse, required this.scrollController,
  });

  final List reserveList;
  final Function(int index) onTap;
  final bool isReverse;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: reserveList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: (){
            onTap(index);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 41.h,
            decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFDDDDDD),
                    width: 1.0,
                  ),
                ),
                color: Colors.white
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 65.w,
                    child: Center(
                      child: Text(
                        isReverse
                        ? "${reserveList.length - index}"
                        : '${index + 1}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontVariations: const [FontVariation('wght', 500)],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 106.5.w,
                    child: Center(
                      child: Text(
                        NumberFormat('#,###').format(reserveList[index]["price"]),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontVariations: const [FontVariation('wght', 500)],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 106.5.w,
                    child: Center(
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(reserveList[index]["reserveStart"].toDate()),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontVariations: const [FontVariation('wght', 500)],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50.w,
                    child: Center(
                      child: Text(
                        reserveList[index]["status"],
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontVariations: const [FontVariation('wght', 500)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

