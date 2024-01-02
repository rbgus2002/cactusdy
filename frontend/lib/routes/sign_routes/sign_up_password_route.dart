import 'package:flutter/material.dart';
import 'package:groupstudy/routes/sign_routes/sign_up_detail_route.dart';
import 'package:groupstudy/services/auth.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/primary_button.dart';
import 'package:groupstudy/widgets/buttons/slow_back_button.dart';
import 'package:groupstudy/widgets/input_field.dart';

class SignUpPasswordRoute extends StatefulWidget {
  final String phoneNumber;

  const SignUpPasswordRoute({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<SignUpPasswordRoute> createState() => _SignUpPasswordRouteState();
}

class _SignUpPasswordRouteState extends State<SignUpPasswordRoute> {
  final GlobalKey<InputFieldState> _passwordEditor = GlobalKey();
  final GlobalKey<InputFieldState> _passwordConfirmEditor = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SlowBackButton(),),
      body: SingleChildScrollView(
        padding: Design.edgePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.local.inputPassword,
              style: TextStyles.head2,),
            Design.padding48,

            // Password
            InputField(
              key: _passwordEditor,
              obscureText: true,
              hintText: context.local.password,
              maxLength: Auth.passwordMaxLength,
              validator: _passwordValidator,
              onEditingComplete: () => FocusScope.of(context).nextFocus(),),
            Design.padding16,

            // Password Confirm
            InputField(
              key: _passwordConfirmEditor,
              obscureText: true,
              hintText: context.local.confirmPassword,
              validator: _passwordConfirmValidator,
              onEditingComplete: _verifyPassword,
              maxLength: Auth.passwordMaxLength,),
            Design.padding(132),

            // Complete Button
            PrimaryButton(
              text: context.local.complete,
              onPressed: _verifyPassword,),
          ],),
      ),
    );
  }

  String? _passwordValidator(String? input) {
    if (input == null || input.isEmpty) {
      return context.local.inputHint2(context.local.password);
    }
    return null;
  }

  String? _passwordConfirmValidator(String? input) {
    if (input == null || input != _passwordEditor.currentState?.text) {
      return context.local.mismatchPassword;
    }
    return null;
  }

  void _verifyPassword() async {
    if (_passwordEditor.currentState!.validate() &&
        _passwordConfirmEditor.currentState!.validate()) {
      String password = _passwordEditor.currentState!.text;

      Util.pushRoute(context, (context) =>
          SignUpDetailRoute(
            phoneNumber: widget.phoneNumber,
            password: password,));
    }
  }
}