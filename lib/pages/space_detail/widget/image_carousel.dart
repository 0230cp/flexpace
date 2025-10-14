import 'package:carousel_slider/carousel_controller.dart' as carousel;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flexpace/global/global_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageCarousel extends StatelessWidget {
  final List list;
  final int slider;
  final Function(int, CarouselPageChangedReason)? onPageChanged;
  final CarouselSliderController carouselController;

  const ImageCarousel({
    super.key,
    required this.list,
    required this.slider,
    this.onPageChanged,
    required this.carouselController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
          itemCount: list.length,
          itemBuilder: (context, index, realIndex) {
            return GlobalImageWidget(
              list.isEmpty ? '' : list[index]['url'],
              width: MediaQuery.sizeOf(context).width,
              fit: BoxFit.fill,
            );
          },
          carouselController: carouselController,
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              onPageChanged!(index, reason);
            },
            pageSnapping: true,
            enlargeCenterPage: true,
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 10),
            scrollDirection: Axis.horizontal,
            height: 242.h,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              list.length,
              (index) => Opacity(
                    opacity: slider == index ? 1 : 0.3,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      margin: EdgeInsets.only(bottom: 16.h, left: 8.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white),
                    ),
                  )),
        )
      ],
    );
  }
}
