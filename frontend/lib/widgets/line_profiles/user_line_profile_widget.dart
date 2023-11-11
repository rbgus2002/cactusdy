import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/widgets/buttons/squircle_widget.dart';

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

  static const double _popupWidth = 250;
  static const double _popupHeight = 44;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // User Profile Image
          SquircleWidget(
            scale: _height,
            child: (widget.user.picture.isNotEmpty) ?
                CachedNetworkImage(
                    imageUrl: widget.user.picture,
                    fit: BoxFit.cover) : null,),
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
              ],
            ),
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
              position: PopupMenuPosition.under,
              itemBuilder: popupMenuBuilder,
              constraints: const BoxConstraints(minWidth: _popupWidth),
              shape: const RoundedRectangleBorder(
                borderRadius: Design.borderRadiusBig,),),)
        ],)
    );
  }

  List<PopupMenuEntry> popupMenuBuilder(BuildContext context) {
    return [
      // edit profile
      itemEntry(
        text: context.local.editProfile,
        icon: const Icon(CustomIcons.write),),

      // setting
      itemEntry(
          text: context.local.setting,
          icon: const Icon(CustomIcons.setting_outline,),),
    ];
  }

  PopupMenuEntry itemEntry({ required String text, required Icon icon }) {
    return  PopupMenuItem(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: _popupHeight,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text, style: TextStyles.body1),
              icon,
            ],
        ),
    );
  }
}