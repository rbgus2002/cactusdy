
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';

class InputField extends StatefulWidget {
  final String? hintText;
  final FormFieldValidator<String>? validator;

  const InputField({
    Key? key,
    this.hintText,
    this.validator,
  }) : super(key: key);

  @override
  State<InputField> createState() => InputFieldState();
}

class InputFieldState extends State<InputField> {
  static const _defaultBorder = OutlineInputBorder(
    borderRadius: Design.borderRadius,
    borderSide: BorderSide.none,);

  static const _focusedBorderSide = OutlineInputBorder(
    borderRadius: Design.borderRadius,
    borderSide: BorderSide(color: ColorStyles.mainColor));

  static const _errorBorderSide = OutlineInputBorder(
    borderRadius: Design.borderRadius,
    borderSide: BorderSide(color: ColorStyles.errorColor),);

  final TextEditingController _textEditingController = TextEditingController();
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    final additionalColor = Theme.of(context).extension<AdditionalColor>()!;

    return TextField(
      controller: _textEditingController,
      style: TextStyles.body1,
      decoration: InputDecoration(
        contentPadding: Design.buttonPadding,

        hintText: widget.hintText,
        hintStyle: TextStyles.body1.copyWith(
          color: additionalColor.grey400,),

        filled: true,
        fillColor: (_isError())? additionalColor.inputFieldBackgroundErrorColor : additionalColor.inputFieldBackgroundColor,

        border: _defaultBorder,
        disabledBorder: _defaultBorder,
        errorBorder: _defaultBorder,
        focusedBorder: (_isError())? _errorBorderSide : _focusedBorderSide,
        focusedErrorBorder: _errorBorderSide,

        error: (_isError())? Transform.translate(
            offset: Offset(-Design.buttonPadding.left, 0),
            child: Text(_errorText!, style: TextStyles.body1.copyWith(color: ColorStyles.errorColor),)) : null,
      ),
    );
  }

  bool _isError() {
    return (_errorText != null);
  }

  bool validate() {
    return (_validator(_textEditingController.text) == null);
  }

  String? _validator(String? text) {
    if (widget.validator != null) {
      setState(() => _errorText = widget.validator!(text));
    }

    return null;
  }
}