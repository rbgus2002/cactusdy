import 'package:flutter/material.dart';
import 'package:groupstudy/models/user_notification.dart';
import 'package:groupstudy/routes/template/pageable_route_template.dart';
import 'package:groupstudy/services/auth.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/pageable.dart';
import 'package:groupstudy/widgets/buttons/focused_menu_button.dart';
import 'package:groupstudy/widgets/buttons/slow_back_button.dart';
import 'package:groupstudy/widgets/item_entry.dart';
import 'package:groupstudy/widgets/notification_item.dart';

class NotificationCenterRoute extends StatefulWidget {
  final int userId;

  const NotificationCenterRoute({
    super.key,
    required this.userId,
  });

  @override
  State<NotificationCenterRoute> createState() =>
      _NotificationCenterRouteState();
}

class _NotificationCenterRouteState
    extends PageableRouteState<NotificationCenterRoute, UserNotification> {
  static const double _iconSize = 32;

  @override
  Pageable<UserNotification> createPageable() {
    return Pageable<UserNotification>(
      fetchSize: 20,
      fetchFunction: (page, size) =>
          UserNotification.getNotifications(widget.userId, page, size),
    );
  }

  @override
  NullableIndexedWidgetBuilder get itemBuilder => (context, index) {
        return NotificationItem(
          notification: pageable.pageInfo!.contents[index],
        );
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: SlowBackButton(),
          foregroundColor: context.extraColors.grey900,
          actions: [_notificationCenterPopupMenu()],
          title: Text(context.local.notificationCenter)
      ),
      body: super.build(context),
    );
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
        icon: const Icon(CustomIcons.check2),
        onTap: () {
            UserNotification.markAsRead(Auth.signInfo!.userId, [], true)
                .then((_) => refresh());
          }
      ),
    ];
  }
}
