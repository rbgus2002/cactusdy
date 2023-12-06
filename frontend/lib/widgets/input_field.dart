
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/widgets/text_counter.dart';

class InputField extends StatefulWidget {
  final String? initText;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TapRegionCallback? onTapOutSide;
  final FocusNode? focusNode;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool obscureText;
  final bool enable;
  final bool counter;
  final Color? backgroundColor;

  const InputField({
    Key? key,
    this.initText,
    this.hintText,
    this.obscureText = false,
    this.onChanged,
    this.onTapOutSide,
    this.focusNode,
    this.validator,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.enable = true,
    this.counter = false,
    this.backgroundColor,
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

  late final TextEditingController _textEditingController;

  String? _errorText;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.initText??"");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          enabled: widget.enable,
          controller: _textEditingController,
          style: TextStyles.body1,
          maxLength: widget.maxLength,
          minLines: widget.minLines,
          maxLines: widget.maxLines??1,
          obscureText: widget.obscureText,
          textAlign: TextAlign.justify,
          focusNode: widget.focusNode,
          onChanged: onChange,
          onTapOutside: widget.onTapOutSide??((event) => FocusScope.of(context).unfocus()),
          decoration: InputDecoration(
            contentPadding: Design.textFieldPadding,

            hintText: widget.hintText,
            hintStyle: TextStyles.body1.copyWith(
              color: context.extraColors.grey400,),

            filled: true,
            fillColor: (_isError())?
                context.extraColors.inputFieldBackgroundErrorColor :
                widget.backgroundColor??context.extraColors.inputFieldBackgroundColor,

            border: _defaultBorder,
            disabledBorder: _defaultBorder,
            errorBorder: _defaultBorder,
            focusedBorder: (_isError())? _errorBorderSide : _focusedBorderSide,
            focusedErrorBorder: _errorBorderSide,

            counterText: "",
            error: (_isError())? Transform.translate(
                offset: Offset(-Design.buttonPadding.left, 0),
                child: Text(errorText!, style: TextStyles.body1.copyWith(color: ColorStyles.errorColor),)) : null,
          ),),

        // Counter
        Visibility(
          visible: (widget.counter && (widget.maxLength != null)),
          child: TextCounter(
            length: _textEditingController.text.length,
            maxLength: widget.maxLength!,),),
      ],
    );
  }

  void onChange(String input) {
    if (widget.onChanged != null) {
      widget.onChanged!(input);
    }

    // For Counter
    if (widget.counter) {
      setState(() {});
    }
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