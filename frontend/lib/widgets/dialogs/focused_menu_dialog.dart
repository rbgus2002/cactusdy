import 'package:flutter/material.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/utilities/extensions.dart';

class FocusedMenuDialog {
  FocusedMenuDialog._();

  static const double itemHeight = 44;

  static Future<dynamic> showDialog({
    required BuildContext context,
    required List<PopupMenuEntry> items,
  }) {
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    late Offset offset = Offset(0.0, button.size.height);

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
          button.localToGlobal(offset, ancestor: overlay),
          button.localToGlobal(button.size.bottomRight(Offset.zero) + offset,
              ancestor: overlay)),
      Offset.zero & overlay.size,
    );

    return showGeneralDialog(
        context: context,
        barrierColor: context.extraColors.barrierColor!.withAlpha(51),
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pageBuilder: (context, animation, secondaryAnimation) =>
            _buildItemList(context: context, position: position, items: items));
  }

  static Widget _buildItemList({
    required BuildContext context,
    required RelativeRect position,
    required List<PopupMenuEntry> items,
  }) {
    return BackdropFilter(
      filter: Design.basicBlur,
      child: Stack(
        children: [
          Positioned(
            right: position.right,
            top: position.top,
            child: Material(
              color: context.extraColors.grey50!.withAlpha(242),
              borderRadius: Design.borderRadiusBig,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: Design.popupWidth,
                height: itemHeight * items.length,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) => items[index],
                  separatorBuilder: (context, index) =>
                      Divider(height: 1, color: context.extraColors.grey200),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
