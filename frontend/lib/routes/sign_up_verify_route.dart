
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_study_app/routes/sign_up_detail_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/formatter_utility.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/utilities/util.dart';

class SignUpVerifyRoute extends StatefulWidget {
  final String phoneNumber;

  const SignUpVerifyRoute({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<SignUpVerifyRoute> createState() => _SignUpVerifyRouteState();
}

class _SignUpVerifyRouteState extends State<SignUpVerifyRoute> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const int _verifyNumberLength = 6;

  final List<int> inputCode = List<int>.filled(_verifyNumberLength, -1);
  final List<TextEditingController> _controllers = List.generate(_verifyNumberLength, (index) => TextEditingController());

  static const String _titleText = "핸드폰 번호 인증";
  static const String _confirmText = "확인";
  static const String _resendText = "다시 보내기";
  static const String _fillAllCodeText = "인증 번호를 전부 입력해 주세요";
  static const String _discordCodeText = "인증 번호가 일치하지 않습니다!";

  String _errorText = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_titleText, style: TextStyles.titleSmall,),),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: Design.edgePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Design.padding30,
              Container(
                padding: Design.edgePadding,
                margin: Design.bottom15,
                color: ColorStyles.grey,
                child: Text(
                  "인증 번호를 \"${FormatterUtility.phoneNumberFormatter(widget.phoneNumber)}\"에 문자로 보내드렸어요. 문자에 적혀있는 인증 번호를 아래 빈칸에 입력해 주세요. 인증 번호는 3분 뒤 만료됩니다.", //< FIXME is this BEST?
                  style: TextStyles.bodyMedium,
                  textAlign: TextAlign.justify,
                ),
              ),
              Design.padding10,
              const Text("인증 번호", style: TextStyles.wideTextStyle),
              Design.padding5,

              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < _verifyNumberLength; ++i)
                      _cell(context, i),

                  ],
                ),
              ),

              Design.padding10,
              Text(_errorText, style: TextStyles.errorTextStyle,),
              Design.padding15,

              ElevatedButton(
                autofocus: true,
                  onPressed: () => checkValidate(context),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: const Text(_confirmText, style: TextStyles.titleSmall,),
                  )
              ),
              TextButton(onPressed: _resend, child: const Text(_resendText)),
            ],
          )
        ),
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
        //maxLength: _isLast(idx)? 1 : null,
        style: TextStyles.numberTextStyle,
        showCursor: false,
        decoration: const InputDecoration(
          hintText: '*',
          counterText: '',
          hintStyle: TextStyles.numberTextStyle,
        ),
        validator: (value) {
          if (value == "") {
            _errorText = _fillAllCodeText;
            return "";
          }

          _errorText = "";
          return null;
        },
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
      int length = min(_verifyNumberLength, idx + value.length);
      for (int cur = idx; cur < length; ++cur) {
        if (cur >= idx + value.length) return;

        inputCode[cur] = int.parse(value[cur - idx]);
        _controllers[cur].text = value[cur - idx];

        if (!_isLast(cur)) FocusScope.of(context).nextFocus();
      }
    }
  }

  bool _isLast(int idx) {
    return (idx >= _verifyNumberLength - 1);
  }

  void checkValidate(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      String inputCodeStr = inputCode.join();
      Auth.verifyCode(widget.phoneNumber, inputCodeStr).then((result) {
        if (result == true) {
          Util.pushRoute(context, (context) =>
              SignUpDetailRoute(phoneNumber: widget.phoneNumber));
        }
        else {
          _errorText = _discordCodeText;
          setState(() { });
        }
      });
    }
    else {
      _errorText = _fillAllCodeText;
      setState(() { });
    }
  }

  void _resend() {
    Auth.requestSingUpVerifyMessage(widget.phoneNumber);
  }
}