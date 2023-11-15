import 'package:flutter/material.dart';
import 'package:group_study_app/models/comment.dart';
import 'package:group_study_app/models/notice.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/comment_widget.dart';
import 'package:group_study_app/widgets/input_field.dart';
import 'package:group_study_app/widgets/tags/notice_reaction_tag.dart';

class NoticeDetailRoute extends StatefulWidget {
  final int noticeId;

  const NoticeDetailRoute({
    Key? key,
    required this.noticeId,
  }) : super(key: key);

  @override
  State<NoticeDetailRoute> createState() => _NoticeDetailRouteState();
}

class _NoticeDetailRouteState extends State<NoticeDetailRoute> {
  static const String _deleteNoticeCautionMessage = "해당 게시물을 삭제하시겠어요?"; //< FIXME
  static const String _deleteNoticeFailMessage = "게시물 삭제에 실패했습니다";

  static const String _checkText = "확인";
  static const String _cancelText = "취소";

  final GlobalKey<InputFieldState> _commentEditor = GlobalKey();
  late final focusNode = FocusNode();

  late Future<Notice> futureNotice;
  late List<Comment> comments;
  int _replyTo = Comment.commentWithNoParent;
  int _commentCount = 0;

  bool _isProcessing = false;

  int _writerId = -1; //< FIXME

  @override
  void initState() {
    super.initState();
    futureNotice = Notice.getNotice(widget.noticeId);
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
              onRefresh: () async => setState(() {}),
              child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                      children: [
                        _noticeBody(),
                        OldDesign.padding15,

                        _commentList(),
                      ]
                  ),
                ),
              ),
          ),
          _writingCommentBox(),
        ],),
      bottomNavigationBar: Design.padding(40),

    );
  }

  List<Widget> _noticePopupMenus() {
    return [
      IconButton(
        icon: const Icon(CustomIcons.writing_outline),
        iconSize: 28,
        onPressed: () { },),

      IconButton(
        icon: const Icon(CustomIcons.trash),
        iconSize: 28,
        onPressed: () {
          _showDeleteNoticeDialog(context); }),
    ];
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
      child: FutureBuilder(
        future: futureNotice,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _writerId = snapshot.data!.writerId;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Design.padding8,

                // Writing Date and Writer Nickname
                Text(
                    '${TimeUtility.getElapsedTime(snapshot.data!.createDate)} '
                        '${snapshot.data!.writerNickname}',
                    style: TextStyles.body2.copyWith(
                        color: context.extraColors.grey500)),
                Design.padding12,

                // Title
                SelectableText(
                  snapshot.data!.title,
                  style: TextStyles.head3.copyWith(
                      color: context.extraColors.grey900),
                  textAlign: TextAlign.justify,),
                Design.padding8,

                // Body
                SelectableText(
                  snapshot.data!.contents,
                  style: TextStyles.body1.copyWith(
                      color: context.extraColors.grey800),
                  textAlign: TextAlign.justify,),
                Design.padding16,

                // Reaction Tag
                NoticeReactionTag(noticeId: snapshot.data!.noticeId,
                    isChecked: snapshot.data!.read,
                    checkerNum: snapshot.data!.checkNoticeCount),
              ],);
          }
          return Design.loadingIndicator;
        },),
    );
  }

  Widget _commentList() {
    return FutureBuilder(
        future: Comment.getComments(widget.noticeId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _commentCount = snapshot.data!['commentCount'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '${context.local.comment} $_commentCount',
                    style: TextStyles.body2.copyWith(color: context.extraColors.grey900),),),
                Design.padding12,

                ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: snapshot.data!['commentInfos'].length,
                    itemBuilder: (context, index) =>
                        CommentWidget(comment: snapshot.data!['commentInfos'][index],
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
    Future.delayed(Duration.zero, ()=> showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          content: const Text(_deleteNoticeCautionMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(_cancelText),),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteNotice();
              },
              child: const Text(_checkText),),
          ],
        )
    ));
  }

  Widget _writingCommentBox() {
    return Container(
      padding: Design.edge8,
      decoration: BoxDecoration(
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
              minLine: 1,
              maxLine: 5,
              maxLength: 100,
              focusNode: focusNode,
              hintText: context.local.inputHint1(context.local.comment),
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
      // #Case : check
      else {
        focusNode.requestFocus();
        _replyTo = index;
      }
    });
  }

  void _writeComment() {
    if (_commentEditor.currentState!.validate()) {
      if (!_isProcessing) {
        _isProcessing = true;

        try {
          int? parentCommentId = (_replyTo != Comment.commentWithNoParent) ?
          comments[_replyTo].commentId : null;
          Future<int> result = Comment.writeComment(
              widget.noticeId, _commentEditor.currentState!.text,
              parentCommentId);

          result.then((newCommentId) {
            if (newCommentId != Comment.commentCreationError) {
              Toast.showToast(
                  context: context,
                  message: "");

              setState(() {
                // reset writing box and reply target
                _commentEditor.currentState!.text = "";
                focusNode.unfocus();
                _replyTo = Comment.commentWithNoParent;
              });
            }
          });
        } on Exception catch (e) {
          Toast.showToast(
              context: context,
              message: Util.getExceptionMessage(e));
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

  void _deleteComment(int commentId) {
    Comment.deleteComment(commentId).then((result) {
      if (result == false) {
        Toast.showToast(context: context, message: _deleteNoticeFailMessage);
      }
      else {
        futureNotice.then((value) => --_commentCount); //< FIXME : this is not validated value, see also removeComment
        setState(() { });
      }}
    );
  }

  void _deleteNotice() {
    Notice.deleteNotice(widget.noticeId).then((result) {
        if (result == false) {
          Toast.showToast(context: context, message: _deleteNoticeFailMessage);
        }
        else { Navigator.of(context).pop(); }
      },
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}
