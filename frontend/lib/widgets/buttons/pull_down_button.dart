

import 'package:flutter/material.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/widgets/dialogs/focused_menu_dialog.dart';

class PullDownButton extends StatefulWidget {
  final String initText;
  final List<PopupMenuEntry> items;

  const PullDownButton({
    Key? key,
    required this.initText,
    required this.items,
  }) : super(key: key);

  @override
  State<PullDownButton> createState() => PullDownButtonState();
}

class PullDownButtonState extends State<PullDownButton> {
  late String _selected;

  set selected(String value) { setState(() => _selected = value); }

  @override
  void initState() {
    super.initState();
    _selected = widget.initText;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: Design.borderRadiusBig,
      onTap: () => FocusedMenuDialog.showDialog(
          context: context,
          items: widget.items),
      child: Container(
        width: Design.popupWidth,
        height: 44,
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,),
        decoration: BoxDecoration(
          borderRadius: Design.borderRadiusBig,
          border: Border.all(color: context.extraColors.grey200!),),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_selected, style: TextStyles.body1,),
            const Icon(CustomIcons.chevron_down,),
          ],),
      ),
    );
  }
}
