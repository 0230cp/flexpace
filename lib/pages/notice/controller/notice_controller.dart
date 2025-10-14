import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoticeController extends GetxController {
RxList noticeList = [].obs;

//페이지네이션 관련
final int limit = 10;
DocumentSnapshot? lastDocument;
RxBool isLoading = false.obs;
RxBool hasMore = true.obs;

  ScrollController noticeListScrollController = ScrollController();


Future<void> getNoticeList({bool isLoadMore = false}) async {
  if (isLoading.value || (!isLoadMore && !hasMore.value)) return;

  isLoading.value = true;
  final collection = FirebaseFirestore.instance.collection('notice');

  try {
    Query query = collection.limit(limit);

      query = query.orderBy('createAt', descending: true);

    if (isLoadMore && lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    final querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      lastDocument = querySnapshot.docs.last;
      final newNotice = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      if (isLoadMore) {
        noticeList.addAll(newNotice);
      } else {
        noticeList.value = newNotice;
      }

      hasMore.value = querySnapshot.docs.length == limit;
    } else {
      hasMore.value = false;
    }
  } catch (e) {
    print('Error fetching category movies: $e');
  } finally {
    isLoading.value = false;
  }
}


  void _scrollListener() {
    if (noticeListScrollController.offset >= noticeListScrollController.position.maxScrollExtent &&
        !noticeListScrollController.position.outOfRange) {
      getNoticeList(isLoadMore: true);
    }
  }

  @override
  void onInit() {
    noticeListScrollController.addListener(_scrollListener);
    getNoticeList();
    super.onInit();
  }

  @override
  void onClose() {
    noticeListScrollController.removeListener(_scrollListener);
    noticeListScrollController.dispose();
    super.onClose();
  }


}
