
import 'package:flutter/material.dart';
import 'package:groupstudy/models/user.dart';
import 'package:groupstudy/routes/sign_routes/sign_in_route.dart';
import 'package:groupstudy/routes/start_route.dart';
import 'package:groupstudy/services/auth.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/primary_button.dart';
import 'package:groupstudy/widgets/buttons/slow_back_button.dart';
import 'package:groupstudy/widgets/pickers/image_picker_widget.dart';
import 'package:groupstudy/widgets/input_field.dart';
import 'package:image_picker/image_picker.dart';

class SignUpDetailRoute extends StatefulWidget {
  final String phoneNumber;
  final String password;

  const SignUpDetailRoute({
    super.key,
    required this.phoneNumber,
    required this.password,
  });

  @override
  State<SignUpDetailRoute> createState() => _SignUpDetailRouteState();
}

class _SignUpDetailRouteState extends State<SignUpDetailRoute> {
  final GlobalKey<InputFieldState> _nameEditor = GlobalKey();
  final GlobalKey<InputFieldState> _nicknameEditor = GlobalKey();

  String _name = "";
  String _nickname = "";
  XFile? _profileImage;

  bool _isProcessing = false;

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
              context.local.setProfileAndNickname,
              style: TextStyles.head2),
            Design.padding(40),

            Container(
              alignment: Alignment.center,
              child: ImagePickerWidget(
                onPicked: (pickedImage) => _profileImage = pickedImage,),),
            Design.padding28,

            InputField(
              key: _nameEditor,
              hintText: context.local.name,
              maxLength: User.nameMaxLength,
              validator: _nameValidator,
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
              onChanged: (input) => _name = input,),
            Design.padding16,

            InputField(
              key: _nicknameEditor,
              hintText: context.local.nickname,
              maxLength: User.nicknameMaxLength,
              validator: _nicknameValidator,
              //onEditingComplete: Util.doNothing, // Assert to do Nothing, because sign up need to be confirm by User
              onChanged: (input) => _nickname = input,),
            Design.padding(64),

            PrimaryButton(
              text: context.local.signUp,
              onPressed: _signUp,),
          ],),
      )
    );
  }

  String? _nameValidator(String? input) {
    if (input == null || input.isEmpty) {
      return context.local.inputHint1(context.local.name);
    }
    return null;
  }

  String? _nicknameValidator(String? input) {
    if (input == null || input.isEmpty) {
      return context.local.inputHint1(context.local.nickname);
    }
    return null;
  }

  void _signUp() async {
    if (_nameEditor.currentState!.validate() &&
        _nicknameEditor.currentState!.validate()) {
      if (!_isProcessing) {
        _isProcessing = true;

        try {
          await Auth.signUp(
              name: _name,
              nickname: _nickname,
              phoneNumber: widget.phoneNumber,
              password: widget.password,
              profileImage: _profileImage).then((value) {
            if (value) {
              Toast.showToast(context: context, message: context.local.successToSignUp);
              Util.pushRouteAndPopUntil(context, (context) => const StartRoute());
              Util.pushRoute(context, (context) => const SignInRoute());
            }
          });
        }
        on Exception catch (e) {
          _nicknameEditor.currentState!.errorText = Util.getExceptionMessage(e);
        }

        _isProcessing = false;
      }
    }
  }
}