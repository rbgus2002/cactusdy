

import 'package:flutter/material.dart';
import 'package:groupstudy/models/study.dart';
import 'package:groupstudy/routes/home_route.dart';
import 'package:groupstudy/routes/studies/study_detail_route.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/primary_button.dart';
import 'package:groupstudy/widgets/buttons/slow_back_button.dart';
import 'package:groupstudy/widgets/input_field.dart';

class StudyParticipantRoute extends StatefulWidget {
  final String invitingCode;

  const StudyParticipantRoute({
    Key? key,
    this.invitingCode = "",
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
      appBar: AppBar(
        leading: const SlowBackButton(),),
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
              initText: widget.invitingCode,
              hintText: context.local.invitingCodeHint,
              maxLength: Study.invitingCodeLength,
              keyboardType: TextInputType.number,
              validator: _invitingCodeValidator,),
            const Spacer(),

            PrimaryButton(
                text: context.local.participate,
                onPressed: _participateStudy),
            Design.padding(24),
          ],),),
    );
  }

  void _participateStudy() async {
    if (_invitingCodeEditor.currentState!.validate()) {
      if (!_isProcessing) {
        _isProcessing = true;
        String inputCode = _invitingCodeEditor.currentState!.text;
        try {
          await Study.joinStudyByInvitingCode(inputCode).then((studyId) =>
            Study.getStudySummary(studyId).then((study) {
              Util.pushRouteAndPopUntil(
                context, (context) => const HomeRoute());
              Util.pushRoute(
                context, (context) => StudyDetailRoute(study: study),);
            }),
          );
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

  String? _invitingCodeValidator(String? input) {
    if (input == null || input.length < Study.invitingCodeLength) {
      return context.local.shortInvitingCode;
    }
    return null;
  }
}
