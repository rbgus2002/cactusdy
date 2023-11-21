import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/routes/setting_route.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/squircle_widget.dart';
import 'package:group_study_app/widgets/item_entry.dart';

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
                    style: TextStyles.body2.copyWith(color: context.extraColors.grey500)),
              ],),
          ),

          // Popup button to edit profile and setting
          SizedBox(
            // for sizing down of PopupMenuButton
            width: 20, // HomeRoute.specialPadding: 16 + 4
            height: _iconSize,
            child: PopupMenuButton(
              icon: Icon(
                  CustomIcons.more_vert,
                  color: context.extraColors.grey500,
                  size: _iconSize,),
              splashRadius: _iconSize / 2,
              padding: EdgeInsets.zero,
              itemBuilder: _popupMenuBuilder,
              constraints: const BoxConstraints(minWidth: Design.popupWidth),),),
        ],)
    );
  }

  List<PopupMenuEntry> _popupMenuBuilder(BuildContext context) {
    return [
      // edit profile
      ItemEntry(
        text: context.local.editProfile,
        icon: const Icon(CustomIcons.writing_square_outline),),

      // setting
      ItemEntry(
        text: context.local.setting,
        icon: const Icon(CustomIcons.setting_outline,),
        onTap: () => Util.pushRoute(context, (context) => const SettingRoute())),
    ];
  }
}