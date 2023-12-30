

import 'package:flutter/material.dart';
import 'package:groupstudy/models/study.dart';
import 'package:groupstudy/services/auth.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:groupstudy/widgets/buttons/primary_button.dart';
import 'package:groupstudy/widgets/buttons/slow_back_button.dart';
import 'package:groupstudy/widgets/dialogs/two_button_dialog.dart';
import 'package:groupstudy/widgets/pickers/image_picker_widget.dart';
import 'package:groupstudy/widgets/input_field.dart';
import 'package:groupstudy/widgets/profile_lists/member_profile_list_widget.dart';
import 'package:image_picker/image_picker.dart';

class StudyEditRoute extends StatefulWidget {
  final Study study;

  const StudyEditRoute({
    Key? key,
    required this.study,
  }) : super(key: key);

  @override
  State<StudyEditRoute> createState() => _StudyEditRouteState();
}

class _StudyEditRouteState extends State<StudyEditRoute> {
  final GlobalKey<InputFieldState> _studyNameEditor = GlobalKey();
  final GlobalKey<InputFieldState> _studyDetailEditor = GlobalKey();

  late final bool _isHost;
  late Study _studyRef;

  XFile? _studyImage;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _studyRef = widget.study;
    _isHost = (_studyRef.hostId == Auth.signInfo?.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SlowBackButton(),
        title: Text(context.local.editStudy),),
      body: SingleChildScrollView(
          padding: Design.edgePadding,
          child: (_isHost) ?
            _adminView() :
            _userView(),),
      bottomNavigationBar: _doneModifyButton(),
    );
  }

  Widget _doneModifyButton() {
    return Container(
      color: context.extraColors.grey000,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 44),
      child: PrimaryButton(
        text: context.local.doneModify,
        onPressed: () => _updateStudy(),),
    );
  }

  Widget _adminView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Design.padding48,

        // Image Picker
        Container(
          alignment: Alignment.center,
          child: ImagePickerWidget(
            url: widget.study.picture,
            backgroundColor: widget.study.color.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: Design.borderRadius,
              side: BorderSide(color: context.extraColors.grey200!, width: 2),),
            onPicked: (pickedImage) => _studyImage = pickedImage,),),
        Design.padding28,

        // Study Name
        Text(
          context.local.studyName,
          style: TextStyles.head5.copyWith(
              color: context.extraColors.grey900),),
        Design.padding8,

        InputField(
          key: _studyNameEditor,
          initText: _studyRef.studyName,
          hintText: context.local.inputHint1(context.local.studyName),
          maxLength: Study.studyNameMaxLength,
          counter: true,
          validator: _studyNameValidator,
          onChanged: (input) => _studyRef.studyName = input,),
        Design.padding12,

        // Study Detail
        Text(
          context.local.studyDetail,
          style: TextStyles.head5.copyWith(
              color: context.extraColors.grey900),),
        Design.padding8,

        InputField(
          key: _studyDetailEditor,
          initText: _studyRef.detail,
          hintText: context.local.inputHint1(context.local.studyDetail),
          maxLength: Study.studyDetailMaxLength,
          minLines: 2,
          maxLines: 3,
          counter: true,
          validator: _studyDetailValidator,
          onChanged: (input) => _studyRef.detail = input,),
        Design.padding(32),

        // Study Color
        _studyColorWidget(),
        Design.padding32,

        // Study Admin
        _TitleAndHintWidget(
            title: context.local.chooseAdmin,
            hint: context.local.chooseAdminHint),
        Design.padding16,

        MemberProfileListWidget(
          study: _studyRef,
          border: true,
          onTap: _changeAdmin,),
        Design.padding(20),
      ],);
  }

  Widget _userView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Design.padding48,

        // Study Color
        _studyColorWidget(),
      ],);
  }

  Widget _studyColorWidget() {
    return Row(
      children: [
        // Title and Hint
        Expanded(
          child: _TitleAndHintWidget(
              title: context.local.studyColor,
              hint: context.local.studyColorHint),),

        // Color Picker Button
        InkWell(
          onTap: () =>
              BottomSheets.colorPickerBottomSheet(
                context: context,
                onSelected: _changeColor),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: _studyRef.color,),
              Design.padding12,

              Icon(
                CustomIcons.drop_down,
                size: 12,
                color: context.extraColors.grey300,),
            ],),),
      ],
    );
  }

  void _changeAdmin(ParticipantProfile newAdmin) {
    TwoButtonDialog.showProfileDialog(
        context: context,
        text: context.local.ensureToGiveAdminTo(newAdmin.nickname),
        maxLines: 4,

        buttonText1: context.local.confirm,
        onPressed1: () => setState(() => _studyRef.hostId = newAdmin.userId),

        buttonText2: context.local.cancel,
        onPressed2: () {}// << Assert to do nothing
    );
  }

  void _changeColor(Color newColor) {
    setState(() => _studyRef.color = newColor);
  }

  void _updateStudy() async {
    if (!_isHost || _studyNameEditor.currentState!.validate() &&
        _studyDetailEditor.currentState!.validate()) {
      if (!_isProcessing) {
        _isProcessing = true;

        try {
          await Study.updateStudy(_studyRef, _studyImage).then((value) {
            Toast.showToast(
                context: context,
                message: context.local.successToDo(context.local.editing));
            Util.popRoute(context);
          });
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

  String? _studyNameValidator(String? input) {
    if (input == null || input.isEmpty) {
      return context.local.inputHint1(context.local.studyName);
    }
    return null;
  }

  String? _studyDetailValidator(String? input) {
    if (input == null || input.isEmpty) {
      return context.local.inputHint1(context.local.studyDetail);
    }
    return null;
  }
}

class _TitleAndHintWidget extends StatelessWidget {
  final String title;
  final String hint;

  const _TitleAndHintWidget({
    Key? key,
    required this.title,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: TextStyles.head5.copyWith(
              color: context.extraColors.grey900),),
        Design.padding4,

        // Hint
        Text(
          hint,
          style: TextStyles.body2.copyWith(
              color: context.extraColors.grey600),),
      ],
    );
  }
}
