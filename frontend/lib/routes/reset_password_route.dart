
import 'package:flutter/material.dart';
import 'package:group_study_app/routes/sign_in_route.dart';
import 'package:group_study_app/routes/start_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/old_app_icons.dart';
import 'package:group_study_app/themes/old_color_styles.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/themes/old_text_styles.dart';
import 'package:group_study_app/utilities/formatter_utility.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/utilities/util.dart';

class ResetPasswordRoute extends StatefulWidget {
  final String phoneNumber;

  const ResetPasswordRoute({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<ResetPasswordRoute> createState() => _ResetPasswordRouteState();
}

class _ResetPasswordRouteState extends State<ResetPasswordRoute> {
  final _formKey = GlobalKey<FormState>();

  static const String _hintSuffix2Text = "를 입력해주세요";
  static const String _passwordText = "비밀 번호";
  static const String _passwordConfirmText = "비밀 번호(확인)";
  static const String _nameText = "이름";
  static const String _nicknameText = "닉네임";

  static const String _passwordNotSameText = "입력한 비밀 번호가 달라요!";
  static const String _unknownErrorText = "알 수 없는 에러가 발생 하였습니다!";

  static const String _confirmText = "확인";

  String _errorText = "";
  String _newPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: OldDesign.edgePadding,
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("PHONE NUMBER", style: OldTextStyles.titleSmall),
                  TextFormField(
                    controller: TextEditingController(text: FormatterUtility.phoneNumberFormatter(widget.phoneNumber)),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: OldColorStyles.grey,
                      prefixIcon: OldAppIcons.phone,
                    ),
                    enabled: false,
                  ),
                  OldDesign.padding30,

                  const Text("PASSWORD", style: OldTextStyles.titleSmall),
                  TextFormField(
                    obscureText: true,
                    maxLength: Auth.passwordMaxLength,
                    validator: (text) =>
                    ((text!.isEmpty) ? _passwordText + _hintSuffix2Text : null),
                    decoration: const InputDecoration(
                      prefixIcon: OldAppIcons.password,
                      hintText: _passwordText,
                      counterText: "",
                    ),
                    onChanged: (value) => _newPassword = value,
                  ),
                  OldDesign.padding15,

                  TextFormField(
                    obscureText: true,
                    maxLength: Auth.passwordMaxLength,
                    validator: (text) =>
                    ((text != _newPassword) ? _passwordNotSameText : null),
                    decoration: InputDecoration(
                      prefixIcon: OldAppIcons.password,
                      hintText: _passwordConfirmText,
                      counterText: "",
                      errorText: _errorText,
                    ),
                  ),

                  ElevatedButton(
                      onPressed: resetPassword,
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: const Text(_confirmText, style: OldTextStyles.titleSmall,),
                      )
                  ),]
            ),
          ),
        ),
      ),
    );
  }

  void resetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Auth.resetPassword(widget.phoneNumber, _newPassword).then((value) {
          if (value) {
            Toast.showToast(msg: '성공적으로 비밀번호를 수정하였습니다.');
            Util.pushRouteAndPopUtil(context, (context) => const StartRoute());
            Util.pushRoute(context, (context) => const SignInRoute());
          }
          else {
            setState(() => _errorText = _unknownErrorText);
          }
        });
      }
      on Exception catch (e) {
        setState(() => _errorText = Util.getExceptionMessage(e));
      }
    }
  }
}