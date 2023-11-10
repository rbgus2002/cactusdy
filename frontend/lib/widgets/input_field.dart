
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';

class InputField extends StatefulWidget {
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final bool obscureText;
  final bool enable;

  const InputField({
    Key? key,
    this.hintText,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.maxLength,
    this.enable = true,
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
    return TextField(
      enabled: widget.enable,
      controller: _textEditingController,
      style: TextStyles.body1,
      maxLength: widget.maxLength,
      maxLines: 1,
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        contentPadding: Design.textFieldPadding,

        hintText: widget.hintText,
        hintStyle: TextStyles.body1.copyWith(
          color: context.extraColors.grey400,),

        filled: true,
        fillColor: (_isError())? context.extraColors.inputFieldBackgroundErrorColor : context.extraColors.inputFieldBackgroundColor,

        border: _defaultBorder,
        disabledBorder: _defaultBorder,
        errorBorder: _defaultBorder,
        focusedBorder: (_isError())? _errorBorderSide : _focusedBorderSide,
        focusedErrorBorder: _errorBorderSide,

        counterText: "",
        error: (_isError())? Transform.translate(
            offset: Offset(-Design.buttonPadding.left, 0),
            child: Text(errorText!, style: TextStyles.body1.copyWith(color: ColorStyles.errorColor),)) : null,
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  bool _isError() {
    return (errorText != null);
  }

  bool validate() {
    return (_validator(_textEditingController.text) == null);
  }

  String? _validator(String? text) {
    if (widget.validator != null) {
      setState(() => errorText = widget.validator!(text));
      return errorText;
    }

    return null;
  }

  String get text => _textEditingController.text;
  set text(String text) {
    setState(() => _textEditingController.text = text );
  }

  String? get errorText => _errorText;
  set errorText(String? text) {
    setState(() => _errorText = text);
  }
}