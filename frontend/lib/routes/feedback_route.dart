

import 'package:flutter/material.dart';
import 'package:groupstudy/models/feedback.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/primary_button.dart';
import 'package:groupstudy/widgets/buttons/pull_down_button.dart';
import 'package:groupstudy/widgets/buttons/slow_back_button.dart';
import 'package:groupstudy/widgets/input_field.dart';
import 'package:groupstudy/widgets/item_entry.dart';

class FeedbackRoute extends StatefulWidget {
  const FeedbackRoute({super.key});

  @override
  State<FeedbackRoute> createState() => _FeedbackRouteState();
}

class _FeedbackRouteState extends State<FeedbackRoute> {
  final GlobalKey<InputFieldState> _titleEditor = GlobalKey();
  final GlobalKey<InputFieldState> _contentsEditor = GlobalKey();

  final GlobalKey<PullDownButtonState> _pullDownController = GlobalKey<PullDownButtonState>();

  bool _isProcessing = false;
  AppFeedback type = AppFeedback.values.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.local.feedback),
        leading: const SlowBackButton(isClose: true,),),
      body: SingleChildScrollView(
        padding: Design.edgePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Design.padding8,

            Text(
              context.local.feedbackType,
              style: TextStyles.head5.copyWith(
                color: context.extraColors.grey900,),),
            Design.padding8,

            PullDownButton(
              key: _pullDownController,
              initText: type.text(context),
              items: _buildDropdownMenu(context)),
            Design.padding24,

            Text(
              context.local.feedbackTitle,
              style: TextStyles.head5.copyWith(
                color: context.extraColors.grey900,),),
            Design.padding8,

            InputField(
              key: _titleEditor,
              hintText: context.local.inputHint1(context.local.title),
              maxLength: AppFeedback.titleMaxLength,
              counter: true,
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
              validator: _feedbackTitleValidator,),
            Design.padding12,

            Text(
              context.local.feedbackContent,
              style: TextStyles.head5.copyWith(
                color: context.extraColors.grey900,),),
            Design.padding8,

            InputField(
              key: _contentsEditor,
              hintText: context.local.inputHint1(context.local.content),
              maxLength: AppFeedback.contentsMaxLength,
              minLines: 5,
              maxLines: 5,
              counter: true,
              validator: _feedbackContentValidator,),
            Design.padding48,

            PrimaryButton(
              text: context.local.send,
              onPressed: _sendFeedback,),
          ],)
      ),
    );
  }

  List<PopupMenuItem> _buildDropdownMenu(BuildContext context) {
    return AppFeedback.values.map((feedback) =>
      ItemEntry(
        text: feedback.text(context),
        icon: Icon(feedback.icon()),
        onTap: () {
          type = feedback;
          _pullDownController.currentState!.selected = type.text(context);
        })
    ).toList();
  }

  String? _feedbackTitleValidator(String? input) {
    if (input == null || input.isEmpty) {
      return context.local.inputHint1(context.local.studyName);
    }
    return null;
  }

  String? _feedbackContentValidator(String? input) {
    if (input == null || input.isEmpty) {
      return context.local.inputHint1(context.local.studyDetail);
    }
    return null;
  }

  void _sendFeedback() async {
    if (!_isProcessing) {
      _isProcessing = true;

      try {
        String title = _titleEditor.currentState!.text;
        String contents = _contentsEditor.currentState!.text;

        AppFeedback.sendFeedback(
            type, title, contents).then((value) {
            if (mounted) {
              Toast.showToast(
                  context: context, 
                  message: context.local.successToDo(context.local.send));
            }
            Util.popRoute(context);
          });
      } on Exception catch(e) {
        if (mounted) {
          _contentsEditor.currentState!.errorText =
              Util.getExceptionMessage(e);
        }
      }

      _isProcessing = false;
    }
  }
}
