import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:groupstudy/models/user_notification.dart';
import 'package:groupstudy/services/auth.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/time_utility.dart';

class NotificationItem extends StatefulWidget {
  final UserNotification notification;

  const NotificationItem({
    super.key,
    required this.notification,
  });

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    double opacity = widget.notification.isRead ? 0.4 : 1;

    return Opacity(
      opacity: opacity,
      child: Slidable(
        enabled: !widget.notification.isRead,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.12,
          children: [
            SlidableAction(
              onPressed: (context) => _markAsRead(),
              foregroundColor: Colors.white,
              backgroundColor: context.extraColors.primaryButtonColor!,
              icon: CustomIcons.check2,
            ),
          ],
        ),
        child: Ink(
          child: InkWell(
            child: Padding(
              padding: Design.listItemPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Pin icon
                  _NotificationHeader(notification: widget.notification),
                  Design.padding4,

                  // Notice Body Summary
                  _NotificationBody(notification: widget.notification),
                  Design.padding8,
                ],
              ),
            ),
            onTap: () {
              _markAsRead();
              UserNotification.handleNotification(widget.notification.data);
            }),
        ),
      ),
    );
  }

  void _markAsRead() {
    setState(() {
      widget.notification.isRead = true;
      UserNotification.markAsRead(Auth.signInfo!.userId, [widget.notification]);
    });
  }
}

class _NotificationHeader extends StatelessWidget {
  final UserNotification notification;

  const _NotificationHeader({
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Title
        Expanded(
          child: Text(
            notification.title,
            style: TextStyles.body1.copyWith(
              color: (notification.isRead)
                  ? context.extraColors.grey900
                  : context.extraColors.primaryButtonColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Notified Date
        Text(
          TimeUtility.getElapsedTime(context, notification.createDate),
          style: TextStyles.body3.copyWith(color: context.extraColors.grey500),
        ),
      ],
    );
  }
}

class _NotificationBody extends StatelessWidget {
  final UserNotification notification;

  const _NotificationBody({
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      notification.message,
      style: TextStyles.head4,
      textAlign: TextAlign.justify,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
