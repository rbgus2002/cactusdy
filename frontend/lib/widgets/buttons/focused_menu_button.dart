
import 'package:flutter/material.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/widgets/dialogs/focused_menu_dialog.dart';

class FocusedMenuButton extends StatelessWidget {
  final Icon icon;
  final double? splashRadius;
  final double? width;
  final List<PopupMenuEntry> items;

  const FocusedMenuButton({
    Key? key,
    this.width,
    this.splashRadius,
    required this.icon,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width??48,
        height: 48,
        child: IconButton(
          icon: icon,
          splashRadius: splashRadius??20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: Design.popupWidth),
          onPressed: () => FocusedMenuDialog.showDialog(
              context: context,
              items: items,),),
    );
  }
}
