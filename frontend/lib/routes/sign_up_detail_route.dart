
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:group_study_app/routes/home_route.dart';
import 'package:group_study_app/routes/sign_in_route.dart';
import 'package:group_study_app/routes/sign_up_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/old_app_icons.dart';
import 'package:group_study_app/themes/old_color_styles.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/themes/old_text_styles.dart';
import 'package:group_study_app/utilities/formatter_utility.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';

class SignUpDetailRoute extends StatefulWidget {
  final String phoneNumber;

  const SignUpDetailRoute({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<SignUpDetailRoute> createState() => _SignUpDetailRouteState();
}

class _SignUpDetailRouteState extends State<SignUpDetailRoute> {
  final _formKey = GlobalKey<FormState>();

  static const String _hintSuffix1Text = "을 입력해주세요";  //< FIXME
  static const String _hintSuffix2Text = "를 입력해주세요";
  static const String _passwordText = "비밀 번호";
  static const String _passwordConfirmText = "비밀 번호(확인)";
  static const String _nameText = "이름";
  static const String _nicknameText = "닉네임";

  static const String _passwordNotSameText = "입력한 비밀 번호가 달라요!";

  static const String _confirmText = "확인";

  String _errorText = " ";

  String _password = "";
  String _name = "";
  String _nickname = "";
  String _picture = "";
  String _phoneModel = "string";

  @override
  void initState() {
    super.initState();
    getPhoneModel();
  }

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OldDesign.padding30,
                  //CircleButton(url: '', scale: 128,), << FIXME : IMAGE PICKER
                  OldDesign.padding30,

                  Column(
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
                        onChanged: (value) => _password = value,
                      ),
                      OldDesign.padding15,

                      TextFormField(
                        obscureText: true,
                        maxLength: Auth.passwordMaxLength,
                        validator: (text) =>
                        ((text != _password) ? _passwordNotSameText : null),
                        decoration: const InputDecoration(
                          prefixIcon: OldAppIcons.password,
                          hintText: _passwordConfirmText,
                          counterText: "",
                        ),
                      ),
                      OldDesign.padding30,

                      const Text("NAME", style: OldTextStyles.titleSmall),
                      TextFormField(
                        maxLength: Auth.passwordMaxLength,
                        validator: (text) =>
                        ((text!.isEmpty) ? _nameText + _hintSuffix1Text : null),
                        decoration: const InputDecoration(
                          prefixIcon: OldAppIcons.person,
                          hintText: _nameText,
                          counterText: "",
                        ),
                        onChanged: (value) => _name = value,
                      ),
                      OldDesign.padding30,


                      const Text("NICKNAME", style: OldTextStyles.titleSmall),
                      TextFormField(
                        maxLength: Auth.passwordMaxLength,
                        validator: (text) =>
                        ((text!.isEmpty) ? _nicknameText + _hintSuffix1Text : null),
                        decoration: const InputDecoration(
                          prefixIcon: OldAppIcons.edit,
                          hintText: _nicknameText,
                          counterText: "",
                        ),
                        onChanged: (value) => _nickname = value,
                      ),
                    ],),
                  OldDesign.padding15,

                  Text(_errorText, style: OldTextStyles.errorTextStyle,),
                  OldDesign.padding30,

                  ElevatedButton(
                      onPressed: signUp,
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: const Text(_confirmText, style: OldTextStyles.titleSmall,),
                      )
                  ),
                  OldDesign.padding60,
                ]
            ),
          ),
        ),
      ),
    );
  }

  void getPhoneModel() async {
    final deviceInfo = await DeviceInfoPlugin();
    //< FIXME : Not Works...
    return;
    if (Platform.isAndroid) {
      deviceInfo.androidInfo.then((build) => _phoneModel = build.device,);
    }
    else if (Platform.isIOS) {
      deviceInfo.iosInfo.then((build) => _phoneModel = build.model);
    }
    else if (Platform.isMacOS) {
      deviceInfo.macOsInfo.then((build) => _phoneModel = build.model);
    }
    else {
      _phoneModel = "OTHER";
    }
    //final deviceInfo = await deviceInfoPlugin.deviceInfo;
    //_phoneModel = deviceInfo.data['name'];
    print(_phoneModel);
  }

  void signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Auth.signUp(name: _name, nickname: _nickname, phoneModel: _phoneModel, picture: _picture, phoneNumber: widget.phoneNumber, password: _password).then((value) {
          if (value) {
            Util.pushRouteAndPopUtil(context, (context) => const SignInRoute());
          }
        });
      }
      on Exception catch (e) {
        setState(() => _errorText = Util.getExceptionMessage(e));
      }
    }
  }
}