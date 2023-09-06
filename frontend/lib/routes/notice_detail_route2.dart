import 'package:flutter/material.dart';
import 'package:group_study_app/models/comment.dart';
import 'package:group_study_app/models/notice.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/widgets/comment_widget.dart';
import 'package:group_study_app/widgets/notice_widgets/comment_list_widget.dart';
import 'package:group_study_app/widgets/notice_widgets/notice_body.dart';
import 'package:group_study_app/widgets/tags/notice_reaction_tag.dart';

class NoticeDetailRoute2 extends StatefulWidget {
  User user = Test.testUser;
  final int noticeId;

  NoticeDetailRoute2({
    super.key,
    required this.noticeId,
  });

  @override
  State<NoticeDetailRoute2> createState() => _NoticeDetailRoute2();
}

class _NoticeDetailRoute2 extends State<NoticeDetailRoute2> {
  static const String _deleteNoticeCautionMessage = "해당 게시물을 삭제하시겠어요?";
  static const String _deleteNoticeFailMessage = "게시물 삭제에 실패했습니다";

  static const String _checkMessage = "확인";
  static const String _cancelMessage = "취소";

  late final _commentEditor = TextEditingController();
  late final _focusNode = FocusNode();

  late Future<Notice> futureNotice;

  @override
  void initState() {
    super.initState();
    futureNotice = Notice.getNotice(widget.noticeId, widget.user.userId);}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          shadowColor: Colors.transparent,
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              splashRadius: 16,
              offset: const Offset(0, 42),

              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text("프로필보기", style: TextStyles.bodyMedium,),
                  onTap: () => _showDeleteNoticeDialog(context),
                ),
                PopupMenuItem(
                  child: Text("삭제하기", style: TextStyles.bodyMedium,),
                  onTap: () => _showDeleteNoticeDialog(context),
                ),
              ],
            )
          ]
      ),

      body: Column (
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Design.padding),
              child: Column(
                  children: [
                    // Notice Body
                    NoticeBody(noticeId: widget.noticeId),
                    Design.padding15,

                    // Comments
                    CommentListWidget(noticeId: widget.noticeId),
                  ]
              ),
            ),
          ),
          _writingCommentBox(),
        ],
      ),

      bottomNavigationBar: BottomAppBar(),
    );
  }

  @override
  void dispose() {
    _commentEditor.dispose();
    _focusNode.dispose();
    super.dispose();
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
              child: const Text(_cancelMessage),),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                //_deleteNotice();
              },
              child: const Text(_checkMessage),),
          ],
        )
    ));
  }

  Widget _writingCommentBox() {
    return Container(
      padding: Design.edge10,
      child: TextField(
        minLines: 1, maxLines: 5,
        maxLength: 100,
        style: TextStyles.bodyMedium,
        textAlign: TextAlign.justify,
        controller: _commentEditor,
        focusNode: _focusNode,

        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          //hintText: _commentHintMessage,

          suffixIcon: IconButton(
            icon: const Icon(Icons.send, size: 16),
            splashRadius: 16,
            onPressed: () {
              if (_checkValidate()) {
                //_writeComment();
              }
            },
          ),
        ),
      ),
    );
  }


  bool _checkValidate() {
    if (_commentEditor.text.isEmpty) {
      //Toast.showToast(msg: _commentHintMessage);
      return false;
    }
    return true;
  }
/*
  void _writeComment() {
    int? parentCommentId = (_selectedIdx != Comment.commentWithNoParent)? comments[_selectedIdx].commentId : null;
    Future<int> result = Comment.writeComment(
        widget.user.userId, widget.noticeId, _commentEditor.text, parentCommentId);

    result.then((newCommentId) {
      if (newCommentId != Comment.commentCreationError) {
        setState(() {
          // writing box reset
          _commentEditor.text = "";
          _focusNode.unfocus();

          // commentList reloads
          futureComments = Comment.getComments(widget.noticeId);
          futureNotice.then((value) => ++value.commentCount); //< FIXME : this is not validated value, see also removeComment
        });
      }
      else {
        Toast.showToast(msg: _writingFailMessage);
      }
    });
  }

  void _deleteNotice() {
    Notice.deleteNotice(widget.noticeId).then((result) {
      if (result == false) {
        Toast.showToast(msg: _deleteNoticeFailMessage);
      }
      else {
        Navigator.of(context).pop();
      }
    },
    );
  }

 */
}