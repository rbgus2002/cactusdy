
import 'package:flutter/material.dart';
import 'package:groupstudy/routes/home_route.dart';
import 'package:groupstudy/routes/sign_routes/reset_password_verify_route.dart';
import 'package:groupstudy/services/auth.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/formatter_utility.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/primary_button.dart';
import 'package:groupstudy/widgets/buttons/slow_back_button.dart';
import 'package:groupstudy/widgets/input_field.dart';

class SignInRoute extends StatefulWidget {
  const SignInRoute({ super.key, });

  @override
  State<SignInRoute> createState() => _SignInRouteState();
}

class _SignInRouteState extends State<SignInRoute> {
  final GlobalKey<InputFieldState> _phoneNumberEditor = GlobalKey();
  final GlobalKey<InputFieldState> _passwordEditor = GlobalKey();

  String _phoneNumber = "";
  String _password = "";

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SlowBackButton(),
        title: Text(context.local.signIn),),
        body: SingleChildScrollView(
          child: Container(
            padding: Design.edgePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Design.padding28,

                // Phone Number
                Text(context.local.phoneNumber, style: TextStyles.head5,),
                Design.padding8,

                InputField(
                  key: _phoneNumberEditor,
                  keyboardType: TextInputType.number,
                  maxLength: Auth.phoneNumberMaxLength,
                  validator: _phoneNumberValidator,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  onChanged: (input) {
                    _phoneNumber = Formatter.getNumberOnly(input);
                    _phoneNumberEditor.currentState!.text =
                        Formatter.phoneNumberFormatter(_phoneNumber);
                  },),
                Design.padding12,

                // Password
                Text(context.local.password, style: TextStyles.head5,),
                Design.padding8,

                InputField(
                  key: _passwordEditor,
                  obscureText: true,
                  maxLength: Auth.passwordMaxLength,
                  validator: _passwordValidator,
                  onEditingComplete: _signIn,
                  onChanged: (input) => _password = input,),
                Design.padding(80),

                // SignIn Button
                PrimaryButton(
                  text: context.local.confirm,
                  onPressed: _signIn,),
                Design.padding4,

                // Forgot Password Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.local.forgotPassword,
                      style: TextStyles.head5.copyWith(color: context.extraColors.grey500),),

                    TextButton(
                      onPressed: () => Util.pushRoute(context, (context) =>
                          const ResetPasswordVerifyRoute()),
                      child : Text(context.local.resetPassword,),),
                  ],)
              ],),
          ),
        ),
      );
  }

  String? _phoneNumberValidator(String? input) {
    if (input == null || input.isEmpty) {
      return context.local.inputHint2(context.local.phoneNumber);
    }
    return null;
  }

  String? _passwordValidator(String? input) {
    if (input == null || input.isEmpty) {
      return context.local.inputHint2(context.local.password);
    }
    return null;
  }

  void _signIn() async {
    if (_phoneNumberEditor.currentState!.validate() &&
      _passwordEditor.currentState!.validate()) {
      if (!_isProcessing) {
        _isProcessing = true;

        try {
          await Auth.signIn(_phoneNumber, _password).then((value) =>
            Util.pushRouteAndPopUntil(context, (context) => const HomeRoute()));
        }
        on Exception catch (e) {
          _passwordEditor.currentState!.errorText
              = Util.getExceptionMessage(e);
        }

        _isProcessing = false;
      }
    }
  }
}