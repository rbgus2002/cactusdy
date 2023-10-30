
import 'package:flutter/material.dart';
import 'package:group_study_app/routes/home_route.dart';
import 'package:group_study_app/routes/reset_password_route.dart';
import 'package:group_study_app/routes/reset_password_verify_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/old_app_icons.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/themes/old_text_styles.dart';
import 'package:group_study_app/utilities/formatter_utility.dart';
import 'package:group_study_app/utilities/util.dart';

class SignInRoute extends StatefulWidget {
  const SignInRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInRoute> createState() => _SignInRouteState();
}

class _SignInRouteState extends State<SignInRoute> {
  final TextEditingController _editingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static const String _phoneNumberHintText = "핸드폰 번호(아이디)를 입력해 주세요";
  static const String _passwordHintText = "비밀 번호를 입력해 주세요";

  static const String _signInText = "로그인";

  String _errorText = "";

  String _phoneNumber = "";
  String _password = "";

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: OldDesign.edgePadding,
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("PHONE NUMBER", style: OldTextStyles.titleSmall),
                TextFormField(
                  controller: _editingController,
                  keyboardType: TextInputType.number,
                  maxLength: Auth.phoneNumberMaxLength,
                  validator: (text) =>
                  ((text!.isEmpty) ? _phoneNumberHintText : null),
                  decoration: const InputDecoration(
                    prefixIcon: OldAppIcons.phone,
                    hintText: _phoneNumberHintText,
                    counterText: "",
                  ),
                  onChanged: (value) {
                    _phoneNumber = FormatterUtility.getNumberOnly(value);
                    setState(() => _editingController.text = FormatterUtility.phoneNumberFormatter(_phoneNumber));
                  },
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
                OldDesign.padding15,

                const Text("PASSWORD", style: OldTextStyles.titleSmall),
                TextFormField(
                  obscureText: true,
                  maxLength: Auth.passwordMaxLength,
                  validator: (text) =>
                  ((text!.isEmpty) ? _passwordHintText : null),
                  decoration: const InputDecoration(
                    prefixIcon: OldAppIcons.password,
                    hintText: _passwordHintText,
                    counterText: "",
                  ),
                  onChanged: (value) => _password = value,
                  onEditingComplete: () => tryToSignIn(),
                ),
              ],),
              OldDesign.padding15,

              Text(_errorText, style: OldTextStyles.errorTextStyle,),
              OldDesign.padding5,

              ElevatedButton(
                  onPressed: tryToSignIn,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: const Text(_signInText, style: OldTextStyles.titleSmall,),
                  )
              ),

              TextButton(
                child: const Text("비밀번호 찾기"),
                onPressed: () => Util.pushRoute(context, (context) => const ResetPasswordVerifyRoute()),
              )
            ]
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  void tryToSignIn() async {
    if (!_isProcessing) {
      _isProcessing = true;

      if (_formKey.currentState!.validate()) {
        try {
          await Auth.signIn(_phoneNumber, _password).then((value) {
            Util.pushRouteAndPopUtil(context, (context) => const HomeRoute());
          });
        }
        on Exception catch (e) {
          setState(() => _errorText = Util.getExceptionMessage(e));
        }
      }
    }

    _isProcessing = false;
  }
}