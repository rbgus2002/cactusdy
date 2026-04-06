import 'package:flutter/material.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/pageable.dart';
import 'package:groupstudy/widgets/haptic_refresh_indicator.dart';

abstract class PageableRouteState<T extends StatefulWidget, S> extends State<T> {
  final ScrollController _scrollController = ScrollController();

  @protected
  late final Pageable<S> pageable;

  @protected
  NullableIndexedWidgetBuilder get itemBuilder;

  Pageable<S> createPageable();

  @override
  void initState() {
    super.initState();
    pageable = createPageable();
    pageable.fetchNextPage(onFetch: () => setState(() {}));

    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final PageInfo<S>? pageInfo = pageable.pageInfo;

    return HapticRefreshIndicator(
      onRefresh: refresh,
      child: (pageInfo == null)
          ? Design.loadingIndicator
          : ListView.separated(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: pageInfo.contents.length,
              itemBuilder: itemBuilder,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: context.extraColors.grey200),
            ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      pageable.fetchNextPage(
        onFetch: () => setState(() {}),
      );
    }
  }

  Future<void> refresh() async {
    pageable.reset();
    pageable.fetchNextPage(
      onFetch: () => setState(() {}),
    );
  }
}
