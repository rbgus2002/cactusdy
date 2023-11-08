
import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/routes/sign_routes/sign_in_route.dart';
import 'package:group_study_app/routes/start_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/secondary_button.dart';
import 'package:group_study_app/widgets/image_picker_widget.dart';
import 'package:group_study_app/widgets/input_field.dart';
import 'package:image_picker/image_picker.dart';

class SignUpDetailRoute extends StatefulWidget {
  final String phoneNumber;
  final String password;

  const SignUpDetailRoute({
    Key? key,
    required this.phoneNumber,
    required this.password,
  }) : super(key: key);

  @override
  State<SignUpDetailRoute> createState() => _SignUpDetailRouteState();
}

class _SignUpDetailRouteState extends State<SignUpDetailRoute> {
  final GlobalKey<InputFieldState> _nameEditor = GlobalKey();
  final GlobalKey<InputFieldState> _nicknameEditor = GlobalKey();

  String _name = "";
  String _nickname = "";
  String _phoneModel = "string";
  XFile? _profileImage;

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    //getPhoneModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: Design.edgePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Util.str(context).setProfileAndNickname,
              style: TextStyles.head2),
            Design.padding(40),

            Container(
              alignment: Alignment.center,
              child: ImagePickerWidget(
                onPicked: (pickedImage) => _profileImage = pickedImage,),),
            Design.padding28,

            InputField(
              key: _nameEditor,
              hintText: Util.str(context).name,
              maxLength: User.nameMaxLength,
              validator: _nameValidator,
              onChanged: (input) => _name = input,),
            Design.padding16,

            InputField(
              key: _nicknameEditor,
              hintText: Util.str(context).nickname,
              maxLength: User.nicknameMaxLength,
              validator: _nicknameValidator,
              onChanged: (input) => _nickname = input,),
            Design.padding(64),

            SecondaryButton(
              text: Util.str(context).signUp,
              onPressed: _tryToSignUp,),
          ],
        ),
      )
    );
  }

  /*
  void getPhoneModel() async {
    final deviceInfo = DeviceInfoPlugin();
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

   */

  String? _nameValidator(String? input) {
    if (input == null || input.isEmpty) {
      return Util.str(context).inputHint1(Util.str(context).name);
    }
    return null;
  }

  String? _nicknameValidator(String? input) {
    if (input == null || input.isEmpty) {
      return Util.str(context).inputHint1(Util.str(context).nickname);
    }
    return null;
  }

  void _tryToSignUp() async {
    if (_nameEditor.currentState!.validate() &&
        _nicknameEditor.currentState!.validate()) {
      if (!_isProcessing) {
        _isProcessing = true;

        try {
          await Auth.signUp(
              name: _name,
              nickname: _nickname,
              phoneModel: _phoneModel,          // FIXME
              picture: "",                      // FIXME
              phoneNumber: widget.phoneNumber,
              password: widget.password).then((value) {
            if (value) {
              Toast.showToast(context: context, message: Util.str(context).successToSignUp);
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