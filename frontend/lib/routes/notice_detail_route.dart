import 'package:flutter/material.dart';
import 'package:group_study_app/models/comment.dart';
import 'package:group_study_app/models/notice.dart';
import 'package:group_study_app/models/sign_info.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/widgets/comment_widget.dart';
import 'package:group_study_app/widgets/dialogs/user_profile_dialog.dart';
import 'package:group_study_app/widgets/tags/notice_reaction_tag.dart';

class NoticeDetailRoute extends StatefulWidget {
  final int noticeId;

  const NoticeDetailRoute({
    Key? key,
    required this.noticeId,
  }) : super(key: key);

  @override
  State<NoticeDetailRoute> createState() => _NoticeDetailRoute();
}

class _NoticeDetailRoute extends State<NoticeDetailRoute> {
  static const String _deleteNoticeCautionMessage = "해당 게시물을 삭제하시겠어요?";
  static const String _deleteNoticeFailMessage = "게시물 삭제에 실패했습니다";

  static const String _commentHintMessage = "댓글을 입력해 주세요";
  static const String _writingFailMessage = "작성에 실패했습니다";

  static const String _checkText = "확인";
  static const String _cancelText = "취소";

  static const String _showProfileText = "프로필 보기";
  static const String _deleteNoticeText = "삭제하기";

  late final _commentEditor = TextEditingController();
  late final focusNode = FocusNode();

  late Future<Notice> futureNotice;
  late List<Comment> comments;
  int _replyTo = Comment.commentWithNoParent;
  int _writerId = -1;

  @override
  void initState() {
    super.initState();
    print(widget.noticeId);
    futureNotice = Notice.getNotice(widget.noticeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        actions: [
          _noticePopupMenu(),
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
                    FutureBuilder(
                        future: futureNotice,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            _writerId = snapshot.data!.writerId;
                            return _NoticeBody(notice: snapshot.data!, focusNode: focusNode);
                          }
                          else {
                            return Design.loadingIndicator; }
                        }
                    ),
                    Design.padding15,

                    // Comments
                    _commentList(),
                  ]
              ),
            ),
          ),
          _writingCommentBox(),
        ],
      ),
    );
  }

  Widget _noticePopupMenu() {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      splashRadius: 16,
      offset: const Offset(0, 42),

      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Text(_showProfileText, style: TextStyles.bodyMedium,),
            onTap: () {
              Future.delayed(Duration.zero, ()=>
                  UserProfileDialog.showProfileDialog(context, _writerId)); }//< FIXME : userId
        ),
        if (Auth.signInfo!.userId == _writerId)
        PopupMenuItem(
          child: const Text(_deleteNoticeText, style: TextStyles.bodyMedium,),
          onTap: () => _showDeleteNoticeDialog(context),
        ),
      ],
    );
  }

  Widget _commentList() {
    return FutureBuilder(
      future: Comment.getComments(widget.noticeId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          comments = snapshot.data!;

          return Column(
            children: [
              for (int i = 0; i < comments.length; ++i)
                CommentWidget(comment: comments[i], index: i,
                    isSelected: (_replyTo == i), setReplyTo: setReplyTo, onDelete: deleteComment),
            ]
          );
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
      padding: Design.edge10,
      child: TextField(
        minLines: 1, maxLines: 5,
        maxLength: 100,
        style: TextStyles.bodyMedium,
        textAlign: TextAlign.justify,
        controller: _commentEditor,
        focusNode: focusNode,

        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: _commentHintMessage,

          suffixIcon: IconButton(
            icon: const Icon(Icons.send, size: 16),
            splashRadius: 16,
            onPressed: () {
              if (_checkValidate()) {
                _writeComment();
              }
            },
          ),
        ),
      ),
    );
  }

  void setReplyTo(int index) {
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

  bool _checkValidate() {
    if (_commentEditor.text.isEmpty) {
      Toast.showToast(msg: _commentHintMessage);
      return false;
    }
    return true;
  }

  void _writeComment() {
    int? parentCommentId = (_replyTo != Comment.commentWithNoParent)? comments[_replyTo].commentId : null;
    Future<int> result = Comment.writeComment(
        widget.noticeId, _commentEditor.text, parentCommentId);

    result.then((newCommentId) {
      if (newCommentId != Comment.commentCreationError) {
        setState(() {
          // writing box reset
          _commentEditor.text = "";
          focusNode.unfocus();

          // commentList reloads
          futureNotice.then((value) => ++value.commentCount); //< FIXME : this is not validated value, see also removeComment
          _replyTo = Comment.commentWithNoParent;
        });
      }
      else {
        Toast.showToast(msg: _writingFailMessage);
      }// FIXME catch error
    });
  }

  void deleteComment(int commentId) {
    Comment.deleteComment(commentId).then((result) {
      if (result == false) {
        Toast.showToast(msg: _deleteNoticeFailMessage);
      }
      else {
        futureNotice.then((value) => --value.commentCount); //< FIXME : this is not validated value, see also removeComment
        setState(() { });
      }}
    );
  }

  void _deleteNotice() {
    Notice.deleteNotice(widget.noticeId).then((result) {
        if (result == false) {
          Toast.showToast(msg: _deleteNoticeFailMessage);
        }
        else { Navigator.of(context).pop(); }
      },
    );
  }

  @override
  void dispose() {
    _commentEditor.dispose();
    focusNode.dispose();
    super.dispose();
  }
}

class _NoticeBody extends StatelessWidget {
  static const String _writerText = "작성자";

  final Notice notice;
  final FocusNode focusNode;

  const _NoticeBody({
    required this.notice,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        // Title
        SelectableText(notice.title,
          style: TextStyles.titleSmall,
          textAlign: TextAlign.justify,
        ),
        Design.padding3,

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(TimeUtility.getElapsedTime(notice.createDate),
              style: TextStyles.bodyMedium,),
            Text('$_writerText : ${notice.writerNickname}',
              style: TextStyles.bodyMedium,),
          ],
        ),
        Design.padding10,

        // Body
        SelectableText(notice.contents,
          style: TextStyles.bodyLarge,
          textAlign: TextAlign.justify,),
        Design.padding15,

        // Reaction Tag
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NoticeReactionTag(noticeId: notice.noticeId,
                  isChecked: notice.read,
                  checkerNum: notice.checkNoticeCount),

              InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  onTap: focusNode.requestFocus,
                  child: Row(
                      children: [
                        const Icon(Icons.comment, size: 18,),
                        Design.padding5,
                        Text('${notice.commentCount}'),
                        Design.padding5
                      ]
                  )
              )
            ]
        ),
      ],
    );
  }
}