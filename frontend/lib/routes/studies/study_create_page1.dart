
import 'package:flutter/material.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/widgets/buttons/primary_button.dart';
import 'package:group_study_app/widgets/input_field.dart';

class StudyCreatePage1 extends StatefulWidget {
  final Function(String, String) getNext;

  const StudyCreatePage1({
    Key? key,
    required this.getNext,
  }) : super(key: key);

  @override
  State<StudyCreatePage1> createState() => _StudyCreatePage1State();
}

class _StudyCreatePage1State extends State<StudyCreatePage1> {
  final GlobalKey<InputFieldState> _studyNameEditor = GlobalKey();
  final GlobalKey<InputFieldState> _studyDetailEditor = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Design.padding(88),

        Text(
          context.local.studyName,
          style: TextStyles.head5.copyWith(
            color: context.extraColors.grey900,),),
        Design.padding8,

        InputField(
          key: _studyNameEditor,
          hintText: context.local.inputHint1(context.local.studyName),
          maxLength: Study.studyNameMaxLength,
          counter: true,
          validator: _studyNameValidator,),
        Design.padding12,

        Text(
          context.local.studyDetail,
          style: TextStyles.head5.copyWith(
            color: context.extraColors.grey900,),),
        Design.padding8,

        InputField(
          key: _studyDetailEditor,
          hintText: context.local.inputHint1(context.local.studyDetail),
          maxLength: Study.studyDetailMaxLength,
          minLines: 3,
          maxLines: 3,
          counter: true,
          validator: _studyDetailValidator,),
        Design.padding(172),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              child: Text(context.local.participateByCode),
              onPressed: () {},),
            Design.padding4,

            PrimaryButton(
              text: context.local.next,
              onPressed: () => _getNext(),),
          ],),
      ],);
  }

  void _getNext() {
    if (_studyNameEditor.currentState!.validate() &&
        _studyDetailEditor.currentState!.validate()) {

      widget.getNext(
        _studyNameEditor.currentState!.text,
        _studyDetailEditor.currentState!.text,);
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