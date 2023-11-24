

import 'package:flutter/material.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/routes/studies/study_create_page3.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/widgets/buttons/primary_button.dart';
import 'package:group_study_app/widgets/input_field.dart';

class StudyParticipantRoute extends StatefulWidget {
  const StudyParticipantRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<StudyParticipantRoute> createState() => _StudyParticipantRouteState();
}

class _StudyParticipantRouteState extends State<StudyParticipantRoute> {
  final GlobalKey<InputFieldState> _invitingCodeEditor = GlobalKey();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: Design.edgePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Design.padding4,

            Text(
              context.local.inputCode,
              style: TextStyles.head2.copyWith(
                color: context.extraColors.grey800,),),
            Design.padding(80),

            InputField(
              key: _invitingCodeEditor,
              hintText: context.local.invitingCodeHint,
              maxLength: Study.invitingCodeLength,
              validator: _invitingCodeValidator,),
            const Spacer(),

            PrimaryButton(
                text: context.local.participate,
                onPressed: _participateStudy), //< FIXME
            Design.padding(24),
          ],),),
    );
  }

  void _participateStudy() {
    if (_invitingCodeEditor.currentState!.validate()) {
      if (!_isProcessing) {
        _isProcessing = true;

        _isProcessing = false;
      }
    }
  }

  String? _invitingCodeValidator(String? input) {
    if (input == null || input.length < Study.invitingCodeLength) {
      return context.local.discordInvitingCode;
    }
    return null;
  }
}
