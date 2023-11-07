
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:group_study_app/routes/sign_routes/sign_up_detail_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/themes/old_text_styles.dart';
import 'package:group_study_app/utilities/formatter_utility.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/util.dart';

class SignUpRoute extends StatefulWidget {
  const SignUpRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpRoute> createState() => _SignUpRouteState();
}

class _SignUpRouteState extends State<SignUpRoute> {
  final TextEditingController _editingController = TextEditingController();
  static const int _verifyNumberLength = 6;

  static const String _titleText = "휴대폰 번호를 알려주세요";
  static const String _sendMessageText = "인증문자 받기";
  static const String _sendMessageAgainText = '인증문자 다시 받기';
  static const String _startText = "시작하기";

  static const String _phoneNumberHintText = "휴대폰 번호";
  static const String _verificationCodeHintText = "인증번호 6자리";
  static const String _fillAllCodeText = "인증 번호를 전부 입력해 주세요";

  static const int _expireTime = 60 * 3; // 3 min
  int _restTime = 0;
  bool _isTimerOn = false;

  String _phoneNumber = "";
  String _inputCode = "";

  String? _phoneNumberErrorText;
  String? _verificationCodeErrorText;

  bool _isVerificationCodeSend = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: OldDesign.edgePadding,
        alignment: Alignment.center,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(_titleText, style: OldTextStyles.titleMedium),
                    OldDesign.padding60,
                    OldDesign.padding15,
                    TextFormField(
                      enabled: !_isVerificationCodeSend,
                      controller: _editingController,
                      keyboardType: TextInputType.number,
                      maxLength: Auth.phoneNumberMaxLength,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: _phoneNumberHintText,
                        counterText: "",
                        errorText: _phoneNumberErrorText,
                      ),
                      onChanged: (value) {
                        _phoneNumber = FormatterUtility.getNumberOnly(value);
                        setState(() => _editingController.text = FormatterUtility.phoneNumberFormatter(_phoneNumber));
                      },
                    ),
                    ElevatedButton(
                      onPressed: _verifyPhoneNumber,
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Text((_isVerificationCodeSend)?
                            '$_sendMessageAgainText (${TimeUtility.secondToString(_restTime)})' : _sendMessageText,
                          style: OldTextStyles.titleSmall,),
                      )
                    ),
                  ],
                ),
                if (_isVerificationCodeSend)
                  Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: _verifyNumberLength,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: _phoneNumberHintText,
                          counterText: "",
                          errorText: _verificationCodeErrorText,
                        ),
                        onChanged: (value) => _inputCode = value,
                      ),
                      ElevatedButton(
                        onPressed: _verifyInputCode,
                        child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: const Text(_startText, style: OldTextStyles.titleSmall,),
                      )
                    ),]
                ),
              ]
          ),
      ),
    );
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  void _verifyPhoneNumber() async {
    if (_phoneNumber == null || _phoneNumber!.isEmpty) {
      _phoneNumberErrorText = _titleText;
    }
    else {
      try {
        await Auth.requestSingUpVerifyMessage(_phoneNumber).then((result) {
          _isVerificationCodeSend = true;
          _startTimer();
        });
      } on Exception catch (e) {
        _phoneNumberErrorText = Util.getExceptionMessage(e);
      }
    }

    setState(() { });
  }

  void _verifyInputCode() async {
    if (_inputCode == null || _inputCode.length < _verifyNumberLength) {
       _verificationCodeErrorText = _fillAllCodeText;
    }

    else {
      try {
        await Auth.verifyCode(_phoneNumber, _inputCode).then((value) {
          if (value == true) {
            Util.pushRoute(context, (context) =>
                SignUpDetailRoute(phoneNumber: _phoneNumber));
          }
        });
      } on Exception catch (e) {
        _verificationCodeErrorText = Util.getExceptionMessage(e);
      }
    }

    setState(() { });
  }

  void _startTimer() {
    _restTime = _expireTime;

    if (!_isTimerOn) {
      _isTimerOn = true;
      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() => --_restTime);

        // stop timer
        if (_restTime <= 0) {
          _restTime = 0;
          timer.cancel();
        }
      });
    }
  }
}