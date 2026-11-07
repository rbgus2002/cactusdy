import 'package:flutter/material.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/pageable.dart';
import 'package:groupstudy/widgets/haptic_refresh_indicator.dart';

abstract class PageableRouteState<T extends StatefulWidget, S> extends State<T> {
  final ScrollController _scrollController = ScrollController();
  late final Pageable<S> _pageable;

  @protected
  Widget buildItem(S item);

  @protected
  Pageable<S> createPageable();

  @override
  void initState() {
    super.initState();
    _pageable = createPageable();
    _pageable.fetchNextPage(onFetch: () => setState(() {}));

    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final PageInfo<S>? pageInfo = _pageable.pageInfo;

    return HapticRefreshIndicator(
      onRefresh: refresh,
      child: (pageInfo == null)
          ? Design.loadingIndicator
          : ListView.separated(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: pageInfo.contents.length,
              itemBuilder: (context, index) =>
                  buildItem(pageInfo.contents[index]),
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: context.extraColors.grey200),
            ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _pageable.fetchNextPage(
        onFetch: () => setState(() {}),
      );
    }
  }

  Future<void> refresh() async {
    _pageable.reset();
    _pageable.fetchNextPage(
      onFetch: () => setState(() {}),
    );
  }
}
