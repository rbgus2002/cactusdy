import 'package:flutter/material.dart';
import 'package:groupstudy/models/user_notification.dart';
import 'package:groupstudy/services/auth.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/pageable.dart';
import 'package:groupstudy/widgets/buttons/focused_menu_button.dart';
import 'package:groupstudy/widgets/buttons/slow_back_button.dart';
import 'package:groupstudy/widgets/haptic_refresh_indicator.dart';
import 'package:groupstudy/widgets/item_entry.dart';
import 'package:groupstudy/widgets/notification_item.dart';

class NotificationCenterRoute extends StatefulWidget {
  const NotificationCenterRoute({
    super.key,
  });

  @override
  State<NotificationCenterRoute> createState() =>
      _NotificationCenterRouteState();
}

class _NotificationCenterRouteState extends State<NotificationCenterRoute> {
  static const double _iconSize = 32;

  final ScrollController _scrollController = ScrollController();
  Pageable<UserNotification> pageableNotificationList =
      Pageable<UserNotification>(
    fetchSize: 20,
    fetchFunction: (page, size) =>
        UserNotification.getNotifications(Auth.signInfo!.userId, page, size),
  );

  @override
  void initState() {
    super.initState();
    pageableNotificationList.fetchNextPage(
      onFetch: () => setState(() {}),
    );
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        pageableNotificationList.fetchNextPage(
          onFetch: () => setState(() {}),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    PageInfo<UserNotification>? pageInfo = pageableNotificationList.pageInfo;

    return Scaffold(
        appBar: AppBar(
          leading: SlowBackButton(),
          foregroundColor: context.extraColors.grey900,
          actions: [_notificationCenterPopupMenu()],
          title: Text(
            context.local.notificationCenter,
          ),
        ),
        body: HapticRefreshIndicator(
          onRefresh: _refresh,
          child: (pageInfo == null)
              ? Design.loadingIndicator
              : ListView.separated(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: pageInfo.contents.length,
                  itemBuilder: (context, index) => NotificationItem(
                    notification: pageInfo.contents[index],
                  ),
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: context.extraColors.grey200,
                  ),
                ),
        ));
  }

  Widget _notificationCenterPopupMenu() {
    return FocusedMenuButton(
      icon: Icon(
        CustomIcons.more_vert,
        color: context.extraColors.grey500,
        size: _iconSize,
      ),
      items: _popupMenuBuilder(context),
    );
  }

  List<PopupMenuEntry> _popupMenuBuilder(BuildContext context) {
    return [
      // mark all as read
      ItemEntry(
        text: context.local.notificationReadAll,
        icon: Icon(CustomIcons.check2),
        onTap: () =>
            UserNotification.markAsRead(Auth.signInfo!.userId, [], true),
      ),
    ];
  }

  Future<void> _refresh() async {
    pageableNotificationList.reset();
    pageableNotificationList.fetchNextPage(
      onFetch: () => setState(() {}),
    );
  }
}
