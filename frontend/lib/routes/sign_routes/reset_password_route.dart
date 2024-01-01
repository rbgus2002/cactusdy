
import 'package:flutter/material.dart';
import 'package:groupstudy/routes/sign_routes/sign_in_route.dart';
import 'package:groupstudy/routes/start_route.dart';
import 'package:groupstudy/services/auth.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/primary_button.dart';
import 'package:groupstudy/widgets/buttons/slow_back_button.dart';
import 'package:groupstudy/widgets/input_field.dart';

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
  final GlobalKey<InputFieldState> _newPasswordEditor = GlobalKey();
  final GlobalKey<InputFieldState> _newPasswordConfirmEditor = GlobalKey();

  String _newPassword = "";
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SlowBackButton(),
        title: Text(context.local.resetPassword),),
      body: SingleChildScrollView(
        padding: Design.edgePadding,
        child: Column(
          children: [
            Design.padding48,

            // New Password
            InputField(
              key: _newPasswordEditor,
              obscureText: true,
              hintText: context.local.password,
              maxLength: Auth.passwordMaxLength,
              validator: _newPasswordValidator,
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
              onChanged: (input) => _newPassword = input,),
            Design.padding16,

            // New Password Confirm
            InputField(
              key: _newPasswordConfirmEditor,
              obscureText: true,
              hintText: context.local.confirmPassword,
              validator: _newPasswordConfirmValidator,
              onEditingComplete: _resetPassword,
              maxLength: Auth.passwordMaxLength,),
            Design.padding(132),

            PrimaryButton(
              text: context.local.start,
              onPressed: _resetPassword,),
          ],
        ),
      ),
    );
  }

  String? _newPasswordValidator(String? input) {
    if (input == null || input.isEmpty) {
      return context.local.inputHint2(context.local.password);
    }
    return null;
  }

  String? _newPasswordConfirmValidator(String? input) {
    if (input == null || input != _newPassword) {
      return context.local.mismatchPassword;
    }
    return null;
  }

  void _resetPassword() async {
    if (_newPasswordEditor.currentState!.validate() &&
      _newPasswordConfirmEditor.currentState!.validate()) {
      if (!_isProcessing) {
        _isProcessing = true;

        try {
          await Auth.resetPassword(widget.phoneNumber, _newPassword).then((value) {
            if (value) {
              Toast.showToast(
                  context: context,
                  message: context.local.successToResetPassword);

              Util.pushRouteAndPopUntil(context, (context) => const StartRoute());
              Util.pushRoute(context, (context) => const SignInRoute());
            }
            else {
              //< FIXME Error Handling
              _newPasswordEditor.currentState!.errorText
                  = context.local.unknownException;
            }
          });
        }
        on Exception catch (e) {
          _newPasswordEditor.currentState!.errorText = Util.getExceptionMessage(e);
        }

        _isProcessing = false;
      }
    }
  }
}