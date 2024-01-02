import 'package:flutter/material.dart';
import 'package:groupstudy/models/user.dart';
import 'package:groupstudy/routes/feedback_route.dart';
import 'package:groupstudy/routes/profiles/profile_edit_route.dart';
import 'package:groupstudy/routes/setting_route.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/focused_menu_button.dart';
import 'package:groupstudy/widgets/buttons/squircle_widget.dart';
import 'package:groupstudy/widgets/dialogs/focused_menu_dialog.dart';
import 'package:groupstudy/widgets/item_entry.dart';

/// User Profile for main route
class UserLineProfileWidget extends StatefulWidget {
  final User user;

  const UserLineProfileWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UserLineProfileWidget> createState() => _UserLineProfileWidgetState();
}

class _UserLineProfileWidgetState extends State<UserLineProfileWidget> {
  static const double _height = 48;
  static const double _iconSize = 32;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // User Profile Image
          SquircleImageWidget(
              scale: _height,
              url: widget.user.profileImage),
          Design.padding12,

          // User nickname & status message
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    widget.user.nickname,
                    style: TextStyles.head3.copyWith(color: context.extraColors.grey800)),
                Text(
                    widget.user.statusMessage,
                    style: TextStyles.body2.copyWith(color: context.extraColors.grey500),
                    overflow: TextOverflow.ellipsis,),
              ],),
          ),

          // Popup button to edit profile and setting
          FocusedMenuButton(
            width: 24,
            icon: Icon(
              CustomIcons.more_vert,
              color: context.extraColors.grey500,
              size: _iconSize,),
            items: _popupMenuBuilder(context)),
      ],)
    );
  }

  List<PopupMenuEntry> _popupMenuBuilder(BuildContext context) {
    return [
      // edit profile
      ItemEntry(
        text: context.local.editProfile,
        icon: const Icon(CustomIcons.writing_outline),
        onTap: () => Util.pushRoute(context, (context) =>
            ProfileEditRoute(user: widget.user)).then((value) =>
                Util.delay(() => setState(() { }),),
        ),),

      // feedback
      ItemEntry(
        text: context.local.feedback,
        icon: const Icon(CustomIcons.comment,),
        onTap: () => Util.pushRouteWithSlideUp(context, (context, animation, secondaryAnimation) =>
            const FeedbackRoute())),

      // setting
      ItemEntry(
        text: context.local.setting,
        icon: const Icon(CustomIcons.setting_outline,),
        onTap: () => Util.pushRoute(context, (context) =>
            const SettingRoute())),
    ];
  }
}