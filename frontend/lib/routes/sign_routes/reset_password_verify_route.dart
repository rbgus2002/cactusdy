
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:group_study_app/routes/sign_routes/reset_password_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/formatter_utility.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/outlined_primary_button.dart';
import 'package:group_study_app/widgets/buttons/primary_button.dart';
import 'package:group_study_app/widgets/input_field.dart';

class ResetPasswordVerifyRoute extends StatefulWidget {
  const ResetPasswordVerifyRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ResetPasswordVerifyRoute> createState() => _ResetPasswordVerifyRouteState();
}

class _ResetPasswordVerifyRouteState extends State<ResetPasswordVerifyRoute> {
  final GlobalKey<InputFieldState> _phoneNumberEditor = GlobalKey();
  final GlobalKey<InputFieldState> _verificationCodeEditor = GlobalKey();

  static const int _expireTime = 60 * 3; // 3 min
  int _restTime = 0;
  Timer? _timer;

  String _phoneNumber = "";
  String _inputCode = "";

  bool _isVerificationCodeSend = false;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.local.resetPassword),),
      body: SingleChildScrollView(
        padding: Design.edgePadding,
        child: Column(
          children: [
            Design.padding48,

            InputField(
              enable: !_isVerificationCodeSend,
              key: _phoneNumberEditor,
              keyboardType: TextInputType.number,
              hintText: context.local.phoneNumber,
              maxLength: Auth.phoneNumberMaxLength,
              validator: _phoneNumberValidator,
              onChanged: (input) {
                _phoneNumber = FormatterUtility.getNumberOnly(input);
                _phoneNumberEditor.currentState!.text = FormatterUtility.phoneNumberFormatter(_phoneNumber);
              },),
            Design.padding16,

            OutlinedPrimaryButton(
              text: (!_isVerificationCodeSend)?
                  context.local.receiveVerificationCode :
                  '${context.local.receiveVerificationCodeAgain} (${TimeUtility.secondToString(context, _restTime)})',
              onPressed: _requestVerificationCode,),
            Design.padding32,

            Visibility(
              visible: _isVerificationCodeSend,
              child: Column(
                children: [
                  InputField(
                    key: _verificationCodeEditor,
                    keyboardType: TextInputType.number,
                    hintText: context.local.verificationCodeHint,
                    maxLength: Auth.verificationCodeLength,
                    validator: _verificationCodeValidator,
                    onChanged: (input) => _inputCode = input,),
                  Design.padding48,

                  PrimaryButton(
                    text: context.local.complete,
                    onPressed: _verifyCode,),
                ],
              )),
          ],
        )
      )
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String? _phoneNumberValidator(String? input) {
    if (input == null || input.isEmpty) {
      return context.local.inputHint2(context.local.phoneNumber);
    }
    return null;
  }

  String? _verificationCodeValidator(String? input) {
    if (input == null || input.length < Auth.verificationCodeLength) {
      return context.local.wrongVerificationCode;
    }
    return null;
  }

  void _requestVerificationCode() async {
    if (!_isProcessing) {
      _isProcessing = true;

      try {
        await Auth.requestResetPasswordVerifyMessage(_phoneNumber).then((result) {
          _isVerificationCodeSend = true;
          Toast.showToast(context: context, message: context.local.sentVerificationCode);
          _startTimer();
        });
      } on Exception catch (e) {
        _phoneNumberEditor.currentState!.errorText = Util.getExceptionMessage(e);
      }

      _isProcessing = false;
    }
  }

  void _verifyCode() async {
    if (_phoneNumberEditor.currentState!.validate() &&
      _verificationCodeEditor.currentState!.validate()) {
      if (!_isProcessing) {
        _isProcessing = true;

        try {
          await Auth.verifyCode(_phoneNumber, _inputCode).then((value) {
            if (value == true) {
              _stopTimer();
              Util.popRoute(context);
              Util.pushRoute(context, (context) =>
                  ResetPasswordRoute(phoneNumber: _phoneNumber));
            }
            else {
              //< FIXME : Error handling
              _verificationCodeEditor.currentState!.errorText
                  = context.local.wrongVerificationCode;
            }
          });
        } on Exception catch (e) {
          _verificationCodeEditor.currentState!.errorText
              = Util.getExceptionMessage(e);
        }

        _isProcessing = false;
      }
    }
  }

  void _startTimer() {
    _restTime = _expireTime;

    _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
        // stop timer
        if (_restTime <= 0) {
          _stopTimer();
        }
        else {
          setState(() => --_restTime);
        }
      });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }
}