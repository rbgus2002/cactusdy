import 'package:flutter/material.dart';
import 'package:group_study_app/models/comment.dart';
import 'package:group_study_app/models/notice.dart';
import 'package:group_study_app/models/notice_summary.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/comment_widget.dart';
import 'package:group_study_app/widgets/dialogs/two_button_dialog.dart';
import 'package:group_study_app/widgets/input_field.dart';
import 'package:group_study_app/widgets/tags/notice_reaction_tag.dart';

class NoticeDetailRoute extends StatefulWidget {
  final NoticeSummary noticeSummary;
  final int studyId;

  const NoticeDetailRoute({
    Key? key,
    required this.noticeSummary,
    required this.studyId,
  }) : super(key: key);

  @override
  State<NoticeDetailRoute> createState() => _NoticeDetailRouteState();
}

class _NoticeDetailRouteState extends State<NoticeDetailRoute> {
  final GlobalKey<InputFieldState> _commentEditor = GlobalKey();
  late final focusNode = FocusNode();

  late Future<Map<String, dynamic>> _futureCommentInfo;
  List<Comment> _comments = [];
  int _replyTo = Comment.commentWithNoParent;

  late Notice _noticeRef;

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _noticeRef = widget.noticeSummary.notice;
    _futureCommentInfo = Comment.getComments(_noticeRef.noticeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: InputBorder.none,
        actions: _noticePopupMenus(),),
      body: Column(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                physics: const AlwaysScrollableScrollPhysics(),
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Column(
                    children: [
                      _noticeBody(),
                      _commentList(),
                    ]),
                ),
            ),),
          ),
          _writingCommentBox(),
        ],),
      bottomNavigationBar: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        height: 40,),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    _futureCommentInfo = Comment.getComments(_noticeRef.noticeId);

    Notice.getNotice(_noticeRef.noticeId).then((refreshedNotice) {
      widget.noticeSummary.notice = refreshedNotice;
      _noticeRef = refreshedNotice;
      setState(() {});
    });
  }

  List<Widget>? _noticePopupMenus() {
    if (_isWriter()) {
      return [
        IconButton(
          icon: const Icon(CustomIcons.writing_outline),
          iconSize: 28,
          onPressed: () {},), //< FIXME

        IconButton(
          icon: const Icon(CustomIcons.trash),
          iconSize: 28,
          onPressed: () => _showDeleteNoticeDialog(context)),
      ];
    }
    return null;
  }

  bool _isWriter() {
    return _noticeRef.writerId == Auth.signInfo?.userId;
  }

  Widget _noticeBody() {
    return Container(
      width: double.maxFinite,
      padding: Design.edgePadding,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.extraColors.grey100!,
            width: 4,),),),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Design.padding8,

            // Writing Date and Writer Nickname
            Text(
              '${TimeUtility.getElapsedTime(context, _noticeRef.createDate)} '
                  '${_noticeRef.writerNickname}',
              style: TextStyles.body2.copyWith(
                  color: context.extraColors.grey500)),
            Design.padding12,

            // Title
            SelectableText(
              _noticeRef.title,
              style: TextStyles.head3.copyWith(
                  color: context.extraColors.grey900),
              textAlign: TextAlign.justify,),
            Design.padding8,

            // Body
            SelectableText(
              _noticeRef.contents,
              style: TextStyles.body1.copyWith(
                  color: context.extraColors.grey800),
              textAlign: TextAlign.justify,),
            Design.padding16,

            // Reaction Tag
            NoticeReactionTag(
                notice: _noticeRef,),
          ],),
    );
  }

  Widget _commentList() {
    return FutureBuilder(
        future: _futureCommentInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int commentCount = snapshot.data!['commentCount'];
            _comments = snapshot.data!['commentInfos'];

            // update value for notice list
            widget.noticeSummary.commentCount = commentCount;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Design.padding16,

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '${context.local.comment} $commentCount',
                    style: TextStyles.body2.copyWith(color: context.extraColors.grey900),),),
                Design.padding12,

                ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _comments.length,
                    itemBuilder: (context, index) =>
                        CommentWidget(
                            comment: _comments[index],
                            studyId: widget.studyId,
                            index: index,
                            isSelected: (_replyTo == index),
                            setReplyTo: _setReplyTo,
                            onDelete: _deleteComment),
                    separatorBuilder: (context, index) =>
                        Design.padding4,),
              ],);
          }
          return const SizedBox();
        }
    );
  }

  void _showDeleteNoticeDialog(BuildContext context) {
    TwoButtonDialog.showProfileDialog(
        context: context,
        text: context.local.confirmDeleteNotice,

        buttonText1: context.local.delete,
        onPressed1: _deleteNotice,

        buttonText2: context.local.cancel,
        onPressed2: Util.doNothing,
    );
  }

  Widget _writingCommentBox() {
    return Container(
      padding: Design.edge8,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: context.extraColors.grey200!,
            width: 1),),),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: InputField(
              key: _commentEditor,
              minLines: 1,
              maxLines: 5,
              maxLength: 100,
              focusNode: focusNode,
              hintText: context.local.inputHint1(context.local.comment),
              onTapOutSide: (event) => Util.doNothing(),
              validator: _commentValidator,),),
          IconButton(
            icon: const Icon(CustomIcons.send, size: 24),
            color: ColorStyles.mainColor,
            splashRadius: 16,
            onPressed: _writeComment,),
        ],),
    );
  }

  String? _commentValidator(String? input) {
    if (input == null || input.isEmpty) {
      return context.local.inputHint1(context.local.comment);
    }
    return null;
  }

  void _setReplyTo(int index) {
    setState(() {
      // #Case : double check => uncheck
      if (_replyTo == index) {
        focusNode.unfocus();
        _replyTo = Comment.commentWithNoParent;
      }
      // #Case : Single check
      else {
        focusNode.requestFocus();
        _replyTo = index;
      }
    });
  }

  void _writeComment() async {
    if (_commentEditor.currentState!.validate()) {
      if (!_isProcessing) {
        _isProcessing = true;

        try {
          int? parentCommentId = _getParentId();
          await Comment.writeComment(
              _noticeRef.noticeId, _commentEditor.currentState!.text,
              parentCommentId).then((newCommentId) {
            if (newCommentId != Comment.commentCreationError) {
              // Reset writing box and reply target
              focusNode.unfocus();
              _commentEditor.currentState!.text = "";
              _replyTo = Comment.commentWithNoParent;

              _refresh();
            }
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

    // non-validated
    else {
      Toast.showToast(
          context: context,
          message: context.local.inputHint1(context.local.comment));
    }
  }

  void _deleteComment(int commentId) async {
    try {
      await Comment.deleteComment(commentId).then((result) =>
          _refresh());
    } on Exception catch(e) {
      if (context.mounted) {
        Toast.showToast(
            context: context,
            message: Util.getExceptionMessage(e));
      }
    }
  }

  void _deleteNotice() async {
    try {
      await Notice.deleteNotice(_noticeRef.noticeId).then((result) =>
        (result)? Navigator.of(context).pop() : null);
    } on Exception catch(e) {
      if (context.mounted) {
        Toast.showToast(
            context: context,
            message: Util.getExceptionMessage(e));
      }
    }
  }

  int? _getParentId() {
    return (_replyTo != Comment.commentWithNoParent) ?
        _comments[_replyTo].commentId
        : null;
  }
}
