
import 'package:flutter/material.dart';
import 'package:group_study_app/routes/home_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/util.dart';

class SignInRoute extends StatefulWidget {
  const SignInRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInRoute> createState() => _SignInRouteState();
}

class _SignInRouteState extends State<SignInRoute> {
  final _formKey = GlobalKey<FormState>();

  static const String _phoneNumberHintText = "핸드폰 번호(아이디)를 입력해 주세요";
  static const String _passwordHintText = "비밀 번호를 입력해 주세요";

  static const String _signInText = "로그인";

  String _errorText = "";

  String _phoneNumber = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: Design.edgePadding,
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
                const Text("PHONE NUMBER", style: TextStyles.titleSmall),
                TextFormField(
                  maxLength: Auth.phoneNumberMaxLength,
                  validator: (text) =>
                  ((text!.isEmpty) ? _phoneNumberHintText : null),
                  decoration: const InputDecoration(
                    prefixIcon: AppIcons.phone,
                    hintText: _phoneNumberHintText,
                    counterText: "",
                  ),
                  onChanged: (value) => _phoneNumber = value,
                ),
                Design.padding15,

                const Text("PASSWORD", style: TextStyles.titleSmall),
                TextFormField(
                  maxLength: Auth.passwordMaxLength,
                  validator: (text) =>
                  ((text!.isEmpty) ? _passwordHintText : null),
                  decoration: const InputDecoration(
                    prefixIcon: AppIcons.password,
                    hintText: _passwordHintText,
                    counterText: "",
                  ),
                  onChanged: (value) => _password = value,
                ),
              ],),
              Design.padding15,

              Text(_errorText, style: TextStyles.errorTextStyle,),
              Design.padding5,

              ElevatedButton(
                  onPressed: tryToSignIn,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: const Text(_signInText, style: TextStyles.titleSmall,),
                  )
              ),
            ]
          ),
        ),
      ),
    );
  }

  void tryToSignIn() async {
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
}