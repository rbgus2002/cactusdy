import 'package:flutter/material.dart';
import 'package:groupstudy/models/notice.dart';
import 'package:groupstudy/models/notice_summary.dart';
import 'package:groupstudy/routes/notices/notice_detail_route.dart';
import 'package:groupstudy/themes/color_styles.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/utilities/util.dart';

class NoticeCreateRoute extends StatefulWidget {
  final int studyId;

  const NoticeCreateRoute({
    Key? key,
    required this.studyId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NoticeCreateRouteState();
}

class _NoticeCreateRouteState extends State<NoticeCreateRoute> {
  final _fromKey = GlobalKey<FormState>();

  String _title = "";
  String _contents = "";

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
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
                  style: TextStyles.head3.copyWith(
                    color: context.extraColors.grey900),
                  maxLength: Notice.titleMaxLength,
                  textAlign: TextAlign.justify,
                  onChanged: (text) => _title = text,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  validator: _titleValidator,
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
                  style: TextStyles.body1.copyWith(
                      color: context.extraColors.grey900,),
                  maxLines: 8,
                  maxLength: Notice.contentsMaxLength,
                  textAlign: TextAlign.justify,
                  onChanged: (text) => _contents = text,
                  validator: _contentsValidator,
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
        onPressed: () => _writeNotice(),
        child: Text(
          context.local.complete,
          style: TextStyles.head5.copyWith(
            color: ColorStyles.mainColor),),
    );
  }

  String? _titleValidator(String? input) {
    if (input == null || input.isEmpty){
      return context.local.inputHint1(context.local.title);
    }

    return null;
  }

  String? _contentsValidator(String? input) {
    if (input == null || input.isEmpty) {
      return context.local.inputHint1(context.local.content);
    }

    return null;
  }

  void _writeNotice() async {
    if (_fromKey.currentState!.validate()) {
      if (!_isProcessing) {
        _isProcessing = true;
        
        try {
          await Notice.createNotice(_title, _contents, widget.studyId).then((newNotice) {
              Util.popRoute(context);
              Util.pushRoute(context, (context) =>
                  NoticeDetailRoute(
                    noticeSummary: NoticeSummary(notice: newNotice, commentCount: 0, pinYn: false),
                    studyId: widget.studyId,
                    onDelete: Util.doNothing,));
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