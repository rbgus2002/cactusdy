

import 'package:flutter/material.dart';
import 'package:groupstudy/models/round.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';

class InputFieldPlace extends StatefulWidget {
  final TextEditingController placeEditingController;
  final VoidCallback onUpdatePlace;

  const InputFieldPlace({
    Key? key,
    required this.placeEditingController,
    required this.onUpdatePlace,
  }) : super(key: key);

  @override
  State<InputFieldPlace> createState() => _InputFieldPlaceState();
}

class _InputFieldPlaceState extends State<InputFieldPlace> {
  final FocusNode _focusNode = FocusNode();

  bool _isEdited = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      maxLength: Round.placeMaxLength,
      maxLines: 1,
      style: TextStyles.body2.copyWith(
          color: context.extraColors.grey800),

      controller: widget.placeEditingController,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,

        hintText: context.local.inputHint2(context.local.place),
        hintStyle: TextStyles.body2.copyWith(
            color: context.extraColors.grey800!.withOpacity(0.5)),

        border: InputBorder.none,
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: context.extraColors.grey700!,)),
        counterText: "",
      ),

      onChanged: (value) => _isEdited = true,
      onTapOutside: (event) => _updatePlace(),
      onSubmitted: (value) => _updatePlace(),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _updatePlace() {
    if (_isEdited) {
      widget.onUpdatePlace();
      _isEdited = false;
    }

    _focusNode.unfocus();
  }
}
