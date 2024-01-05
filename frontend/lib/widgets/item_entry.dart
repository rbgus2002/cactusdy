
import 'package:flutter/material.dart';
import 'package:groupstudy/themes/text_styles.dart';

class ItemEntry extends PopupMenuItem {
  static const double _popupHeight = 44;

  ItemEntry({
    super.key,
    required String text,
    required Icon icon,
    super.onTap,
  }) : super(
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