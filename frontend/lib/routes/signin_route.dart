
import 'package:flutter/material.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';

class SignInRoute extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  static const String _emailHintText = "이메일 주소(아이디)를 입력해 주세요";
  static const String _passwordHintText = "비밀 번호를 입력해 주세요";

  static const String _signInText = "로그인";

  SignInRoute({
    Key? key,
  }) : super(key: key);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("EMAIL ADDRESS", style: TextStyles.titleSmall),
              Design.padding5,
              TextFormField(
                maxLength: Auth.emailMaxLength,
                validator: (text) =>
                ((text!.isEmpty) ? _emailHintText : null),
                decoration: const InputDecoration(
                  prefixIcon: AppIcons.email,
                  hintText: _emailHintText,
                  counterText: "",
                ),
              ),
              Design.padding5,

              const Text("PASSWORD", style: TextStyles.titleSmall),
              Design.padding15,
              TextFormField(
                maxLength: Auth.passwordMaxLength,
                validator: (text) =>
                ((text!.isEmpty) ? _passwordHintText : null),
                decoration: const InputDecoration(
                  prefixIcon: AppIcons.password,
                  hintText: _passwordHintText,
                  counterText: "",
                ),
              ),
              Design.padding30,

              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate())
                      print("AS");
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(_signInText, style: TextStyles.titleSmall,),
                    width: double.infinity,
                  )
              ),
            ]
          ),
        ),
      ),
    );
  }

}