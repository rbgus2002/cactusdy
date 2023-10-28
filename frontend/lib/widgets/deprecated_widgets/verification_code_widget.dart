
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/formatter_utility.dart';

@Deprecated("Not used as a design modification")
class VerificationCodeWidget extends StatefulWidget {
  final int verificationCodeLength;
  final GlobalKey<FormState> formKey;

  const VerificationCodeWidget({
    Key? key,
    required this.formKey,
    this.verificationCodeLength = 6,
  }) : super(key: key);

  @override
  State<VerificationCodeWidget> createState() => _VerificationCodeWidgetState();
}

class _VerificationCodeWidgetState extends State<VerificationCodeWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final List<int> inputCode;
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    inputCode = List<int>.filled(widget.verificationCodeLength, -1);
    _controllers = List.generate(widget.verificationCodeLength, (index) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < widget.verificationCodeLength; ++i)
            _cell(context, i),
        ],
      ),
    );
  }

  Widget _cell(BuildContext context, int idx) {
    return Container(
      width: 55,
      padding: Design.edge5,
      child: TextFormField(
        controller: _controllers[idx],
        keyboardType: TextInputType.number,
        autofocus: true,
        textAlign: TextAlign.center,
        style: TextStyles.numberTextStyle,
        showCursor: false,
        decoration: const InputDecoration(
          hintText: '*',
          counterText: '',
          hintStyle: TextStyles.numberTextStyle,
        ),
        validator: (value) => (value! == "")? " " : null,
        onChanged: (value) => _setNumber(value, idx),
      ),
    );
  }

  void _setNumber(String value, int idx) {
    value = FormatterUtility.getNumberOnly(value);

    if (value.isEmpty) {
      inputCode[idx] = -1;
      if (idx > 0) {
        _controllers[idx].text = "";
        FocusScope.of(context).previousFocus();
      }
    }
    else if (inputCode[idx] != -1) {
      String newNum = _controllers[idx].text[_controllers[idx].selection.extentOffset - 1];

      _controllers[idx].text = newNum;
      inputCode[idx] = int.parse(newNum);

      if (!_isLast(idx)) FocusScope.of(context).nextFocus();

    }

    else {
      int length = min(widget.verificationCodeLength, idx + value.length);
      for (int cur = idx; cur < length; ++cur) {
        if (cur >= idx + value.length) return;

        inputCode[cur] = int.parse(value[cur - idx]);
        _controllers[cur].text = value[cur - idx];

        if (!_isLast(cur)) FocusScope.of(context).nextFocus();
      }
    }
  }

  bool _isLast(int idx) {
    return (idx >= widget.verificationCodeLength - 1);
  }
}