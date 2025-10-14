import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flexpace/common/common.dart';
import 'package:flexpace/common/service/userdata_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class ReserveController extends GetxController {
  RxBool isOldest = true.obs;

   toggleSortOrder() async {
    isOldest.value = !isOldest.value;
    resetAndRefetch();
  }

  RxList reserveList = [].obs;

//페이지네이션 관련
  final int limit = 10;
  DocumentSnapshot? lastDocument;
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;

  ScrollController reserveListScrollController = ScrollController();


  Future<void> getReserveList({bool isLoadMore = false}) async {
    if (isLoading.value || (!isLoadMore && !hasMore.value)) return;

    isLoading.value = true;
    final collection = FirebaseFirestore.instance.collection('reserve');

    try {
      // userId로만 필터링
      Query query = collection
          .where('userId', isEqualTo: UserDataService.to.userData.value.docId)
          .limit(limit);

      if (isLoadMore && lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        lastDocument = querySnapshot.docs.last;
        final newReserve = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        // 로컬에서 정렬
        newReserve.sort((a, b) {
          DateTime dateA = a['reserveStart'].toDate();
          DateTime dateB = b['reserveStart'].toDate();
          return isOldest.value
              ? dateB.compareTo(dateA)  // 오래된 순
              : dateA.compareTo(dateB); // 최신 순
        });

        if (isLoadMore) {
          reserveList.addAll(newReserve);
        } else {
          reserveList.value = newReserve;
        }

        hasMore.value = querySnapshot.docs.length == limit;
      } else {
        hasMore.value = false;
      }
    } catch (e) {
      print('$e');
    } finally {
      isLoading.value = false;
    }
  }

  void resetAndRefetch() {
    lastDocument = null;
    hasMore.value = true;
    reserveList.clear();
    getReserveList();
  }


  void _scrollListener() {
    if (reserveListScrollController.offset >= reserveListScrollController.position.maxScrollExtent &&
        !reserveListScrollController.position.outOfRange) {
      getReserveList(isLoadMore: true);
    }
  }

  getDetail(index) async {
    try {
      var firebaseDoc = FirebaseFirestore.instance
          .collection('space').doc(reserveList[index]['spaceId']);

      if (firebaseDoc != null) {
        var collection = await firebaseDoc.get();
        var data = collection.data();

      Logger().w(data);

        Get.toNamed('/space_detail', arguments: data);

      }
    } catch (e) {
      print('$e');
      Get.showSnackbar(Common.getSnackBar('공간 정보를 불러오는데 실패하였습니다.'));
    }

  }

  @override
  void onInit() {
    reserveListScrollController.addListener(_scrollListener);
    getReserveList();
    super.onInit();
  }

  @override
  void onClose() {
    reserveListScrollController.removeListener(_scrollListener);
    reserveListScrollController.dispose();
    super.onClose();
  }


}
