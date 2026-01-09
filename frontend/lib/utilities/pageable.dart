import 'package:flutter/material.dart';
import 'package:groupstudy/utilities/controllers/event_control.dart';

typedef PageableFetcher<T> = Future<PageInfo<T>> Function(int page, int size);

class PageInfo<T> {
  List<T> contents;
  int page;
  int totalElements;
  int totalPages;

  PageInfo({
    required this.contents,
    required this.page,
    required this.totalElements,
    required this.totalPages,
  });

  factory PageInfo.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return PageInfo(
      contents:
          (json['contents'] as List).map((item) => fromJson(item)).toList(),
      page: json['pageable']['page'],
      totalElements: json['pageable']['totalElements'],
      totalPages: json['pageable']['totalPages'],
    );
  }

  bool hasNextPage() {
    return page + 1 < totalPages;
  }

  void append(PageInfo<T> other) {
    contents.addAll(other.contents);
    page = other.page;
    totalElements = other.totalElements;
    totalPages = other.totalPages;
  }
}

class Pageable<T> {
  final PageableFetcher<T> fetchFunction;
  final int fetchSize;

  PageInfo<T>? pageInfo;
  AsyncLock lock = AsyncLock();

  Pageable({
    required this.fetchFunction,
    this.fetchSize = 10,
  });

  Future<void> _fetchNextPage() async {
    if (pageInfo == null) {
      // Fetch the first page
      pageInfo = await fetchFunction(0, fetchSize);
    } else {
      // Fetch the next page if available
      if (pageInfo!.hasNextPage()) {
        final nextPageData = await fetchFunction(pageInfo!.page + 1, fetchSize);
        pageInfo?.append(nextPageData);
      }
    }
  }

  Future<void> fetchNextPage({VoidCallback? onFetch}) async {
    lock.callOnlyOnce(action: () async {
      await _fetchNextPage();
      onFetch?.call();
    });
  }

  void reset() {
    pageInfo = null;
    lock.release();
  }
}
