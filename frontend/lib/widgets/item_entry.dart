
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/text_styles.dart';

class ItemEntry extends PopupMenuItem {
  static const double _popupHeight = 44;

  ItemEntry({
    Key? key,
    required String text,
    required Icon icon,
    super.onTap,
  }) : super(
      key: key,
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