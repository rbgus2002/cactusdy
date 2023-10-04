
import 'package:flutter/material.dart';
import 'package:group_study_app/routes/home_route.dart';
import 'package:group_study_app/routes/sign_up_verify_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/util.dart';

class SignUpRoute extends StatefulWidget {
  const SignUpRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpRoute> createState() => _SignUpRouteState();
}

class _SignUpRouteState extends State<SignUpRoute> {
  final _formKey = GlobalKey<FormState>();

  static const String _emailHintText = "이메일 주소(아이디)를 입력해주세요";
  static const String _confirmText = "확인";

  String _errorText = "";
  String _email = "";

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
                    const Text("EMAIL ADDRESS", style: TextStyles.titleSmall),
                    TextFormField(
                      maxLength: Auth.emailMaxLength,
                      validator: (text) =>
                      ((text!.isEmpty) ? _emailHintText : null),
                      decoration: const InputDecoration(
                        prefixIcon: AppIcons.email,
                        hintText: _emailHintText,
                        counterText: "",
                      ),
                      onChanged: (value) => _email = value,
                    ),
                    Design.padding15,
                  ],),
                Design.padding15,

                Text(_errorText, style: TextStyles.errorTextStyle,),
                Design.padding5,

                ElevatedButton(
                    onPressed: validateEmail,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: const Text(_confirmText, style: TextStyles.titleSmall,),
                    )
                ),
              ]
          ),
        ),
      ),
    );
  }

  void validateEmail() {
    // verify
    Util.pushRoute(context, (context) => SignUpVerifyRoute(email: _email,));
  }
}