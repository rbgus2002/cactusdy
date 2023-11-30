
import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/routes/sign_routes/sign_in_route.dart';
import 'package:group_study_app/routes/start_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/primary_button.dart';
import 'package:group_study_app/widgets/image_picker_widget.dart';
import 'package:group_study_app/widgets/input_field.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditRoute extends StatefulWidget {
  final User user;

  const ProfileEditRoute({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ProfileEditRoute> createState() => _ProfileEditRouteState();
}

class _ProfileEditRouteState extends State<ProfileEditRoute> {
  final GlobalKey<InputFieldState> _nicknameEditor = GlobalKey();
  final GlobalKey<InputFieldState> _statusMessageEditor = GlobalKey();

  late String _nickname;
  late String _statusMessage;
  XFile? _profileImage;

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _nickname = widget.user.nickname;
    _statusMessage = widget.user.statusMessage;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.local.editProfile),),
        bottomNavigationBar: _doneModifyButton(),
        body: SingleChildScrollView(
          padding: Design.edgePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Design.padding(28),

              Container(
                alignment: Alignment.center,
                child: ImagePickerWidget(
                  url: widget.user.profileImage,
                  onPicked: (pickedImage) => _profileImage = pickedImage,),),
              Design.padding20,

              Text(
                context.local.nickname,
                style: TextStyles.head5.copyWith(
                  color: context.extraColors.grey900),),
              Design.padding8,
              
              InputField(
                key: _nicknameEditor,
                initText: widget.user.nickname,
                hintText: context.local.inputHint1(context.local.nickname),
                maxLength: User.nicknameMaxLength,
                counter: true,
                validator: _nicknameValidator,
                onChanged: (input) => _nickname = input,),
              Design.padding12,

              Text(
                  context.local.statusMessage,
                  style: TextStyles.head5.copyWith(
                      color: context.extraColors.grey900),),
              Design.padding8,

              InputField(
                key: _statusMessageEditor,
                hintText: context.local.inputHint2(context.local.statusMessage),
                maxLength: User.statusMessageMaxLength,
                minLines: 3,
                maxLines: 3,
                counter: true,
                validator: _statusMessageValidator,
                onChanged: (input) => _statusMessage = input,),
            ],
          ),
        )
    );
  }

  Widget _doneModifyButton() {
    return Container(
      color: context.extraColors.grey000,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 44),
      child: PrimaryButton(
        text: context.local.doneModify,
        onPressed: () {}),
    );
  }

  void _updateProfile() async {
    if (_nicknameEditor.currentState!.validate() &&
        _statusMessageEditor.currentState!.validate()) {
      if (!_isProcessing) {
        _isProcessing = true;

        try {
          /*
          await Study.updateStudy(_study, _studyImage).then((value) {
            Toast.showToast(
                context: context,
                message: context.local.successToDo(context.local.editing));
            Util.popRoute(context);
          });
           */
        } on Exception catch(e) {
          if (context.mounted) {
            Toast.showToast(
                context: context,
                message: Util.getExceptionMessage(e));
          }
        }
        _isProcessing = false;
      }
    }
  }

  String? _nicknameValidator(String? input) {
    if (input == null || input.isEmpty) {
      return context.local.inputHint1(context.local.nickname);
    }
    return null;
  }

  String? _statusMessageValidator(String? input) {
    if (input == null || input.isEmpty) {
      return context.local.inputHint2(context.local.statusMessage);
    }
    return null;
  }
}