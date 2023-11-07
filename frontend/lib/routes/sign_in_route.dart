
import 'package:flutter/material.dart';
import 'package:group_study_app/routes/home_route.dart';
import 'package:group_study_app/routes/reset_password_verify_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/app_theme.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/old_app_icons.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/themes/old_text_styles.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/formatter_utility.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/primary_button.dart';
import 'package:group_study_app/widgets/input_field.dart';

class SignInRoute extends StatefulWidget {
  const SignInRoute({
    Key? key,
  }) : super(key: key);

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
    final additionalColor = Theme.of(context).extension<AdditionalColor>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(Util.str(context).signIn),),
        body: SingleChildScrollView(
          child: Container(
            padding: Design.edgePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Design.padding28,
                Text(Util.str(context).phoneNumber, style: TextStyles.head5,),
                Design.padding8,

                InputField(
                  key: _phoneNumberEditor,
                  maxLength: Auth.phoneNumberMaxLength,
                  validator: _phoneNumberValidator,
                  onChanged: (input) {
                    _phoneNumber = FormatterUtility.getNumberOnly(input);
                    setState(() => _phoneNumberEditor.currentState!.text = FormatterUtility.phoneNumberFormatter(_phoneNumber));
                  },),
                Design.padding12,

                Text(Util.str(context).password, style: TextStyles.head5,),
                Design.padding8,

                InputField(
                  key: _passwordEditor,
                  obscureText: true,
                  maxLength: Auth.passwordMaxLength,
                  validator: _passwordValidator,
                  onChanged: (input) {
                    _password = input;
                  },
                ),
                Design.padding(80),

                PrimaryButton(
                  text: Util.str(context).confirm,
                  onPressed: tryToSignIn,
                ),
                Design.padding4,

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Util.str(context).forgotPassword,
                      style: TextStyles.head5.copyWith(color: additionalColor.grey500),),


                    TextButton(
                      onPressed: () => Util.pushRoute(context, (context) => ResetPasswordVerifyRoute()),
                      child : Text(
                          Util.str(context).resetPassword,
                          style: TextStyles.head5,),),
                  ],
                )
              ],
            ),
          ),
        ),
      );
  }

  String? _phoneNumberValidator(String? input) {
    if (input?.isEmpty == true) {
      return Util.str(context).inputHint2(Util.str(context).phoneNumber);
    }
    return null;
  }

  String? _passwordValidator(String? input) {
    if (input?.isEmpty == true) {
      return Util.str(context).inputHint2(Util.str(context).password);
    }
    return null;
  }

  void tryToSignIn() async {
    if (!_isProcessing) {
      _isProcessing = true;
      try {
        await Auth.signIn(_phoneNumber, _password).then((value) {
          Util.pushRouteAndPopUtil(context, (context) => const HomeRoute());
        });
      }
      on Exception catch (e) {
        setState(() {
          _passwordEditor.currentState!.errorText = Util.getExceptionMessage(e);
        });
      }
      /*
      if (_phoneNumberEditor.currentState!.validate() &&
        _passwordEditor.currentState!.validate()) {
        //< FIXME error text from server
      }*/
    }

    _isProcessing = false;
  }
}