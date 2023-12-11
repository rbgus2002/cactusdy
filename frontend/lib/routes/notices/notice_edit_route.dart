import 'package:flutter/material.dart';
import 'package:group_study_app/models/notice.dart';
import 'package:group_study_app/models/notice_summary.dart';
import 'package:group_study_app/routes/notices/notice_detail_route.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/utilities/util.dart';

class NoticeEditRoute extends StatefulWidget {
  final int studyId;
  final NoticeSummary noticeSummary;

  const NoticeEditRoute({
    Key? key,
    required this.studyId,
    required this.noticeSummary,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NoticeEditRouteState();
}

class _NoticeEditRouteState extends State<NoticeEditRoute> {
  final _titleEditingController = TextEditingController();
  final _contentsEditingController = TextEditingController();

  final _fromKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  late final Notice _noticeRef;

  @override
  void initState() {
    super.initState();

    _noticeRef = widget.noticeSummary.notice;

    _titleEditingController.text = _noticeRef.title;
    _contentsEditingController.text = _noticeRef.contents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [ _completeButton(), ],
      ),
      body: Container(
        padding: Design.edgePadding,
        child: SingleChildScrollView(
          child: Form(
            key: _fromKey,
            child: Column(
                children: [
                  Design.padding12,

                  // [Title]
                  TextFormField(
                    controller: _titleEditingController,
                    autofocus: true,
                    style: TextStyles.head3.copyWith(
                        color: context.extraColors.grey900),
                    maxLength: Notice.titleMaxLength,
                    textAlign: TextAlign.justify,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    onChanged: (text) => _noticeRef.title = text,
                    validator: (input) =>
                      (input == null || input.isEmpty)?
                        context.local.inputHint1(context.local.title) : null,
                    decoration: InputDecoration(
                      hintText: context.local.inputHint1(context.local.title),
                      hintStyle: TextStyles.head3.copyWith(
                          color: context.extraColors.grey400),
                      border: InputBorder.none,
                      counterText: "",
                      errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.errorColor),),
                    ),),
                  Design.padding16,

                  // [Contents]
                  TextFormField(
                    controller: _contentsEditingController,
                    style: TextStyles.body1.copyWith(
                      color: context.extraColors.grey900,),
                    maxLines: 8,
                    maxLength: Notice.contentsMaxLength,
                    textAlign: TextAlign.justify,
                    onChanged: (text) => _noticeRef.contents = text,
                    validator: (input) =>
                      (input == null || input.isEmpty)?
                        context.local.inputHint1(context.local.content) : null,
                    decoration: InputDecoration(
                      hintText: context.local.inputHint1(context.local.content),
                      hintStyle: TextStyles.body1.copyWith(
                          color: context.extraColors.grey400),
                      border: InputBorder.none,
                      errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.errorColor),),
                    ),),
                ]),
          ),),
      ),
    );
  }

  Widget _completeButton() {
    return TextButton(
      onPressed: () => _updateNotice(),
      child: Text(
        context.local.complete,
        style: TextStyles.head5.copyWith(
            color: ColorStyles.mainColor),),
    );
  }

  void _updateNotice() async {
    if (_fromKey.currentState!.validate()) {
      if (!_isProcessing) {
        _isProcessing = true;
        try {
          await Notice.updateNotice(_noticeRef).then((newNotice) {
            Util.popRoute(context);
            Util.popRoute(context);
            Util.pushRoute(context, (context) =>
                NoticeDetailRoute(
                  noticeSummary: widget.noticeSummary,
                  studyId: widget.studyId,
                  onDelete: Util.doNothing,
                ));
          });
        } on Exception catch (e) {
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
}