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
import 'package:group_study_app/widgets/tags/notice_reaction_tag.dart';

class NoticeDetailRoute extends StatefulWidget {
  User user = Test.testUser;
  final int noticeId;

  NoticeDetailRoute({
    super.key,
    required this.noticeId,
  });

  @override
  State<NoticeDetailRoute> createState() => _NoticeDetailRoute();
}

class _NoticeDetailRoute extends State<NoticeDetailRoute> {
  static const String _commentHintMessage = "댓글을 입력해 주세요";
  static const String _writingFailMessage = "작성에 실패했습니다";

  late final _commentEditor = TextEditingController();
  late Future<List<Comment>> futureComments;
  late List<Comment> comments;
  int _selectedIdx = Comment.commentWithNoParent;

  @override
  void initState() {
    super.initState();
    futureComments = Comment.getComments(widget.noticeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( shadowColor: Colors.transparent ),
      body: Column (
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Design.padding),
              child: Column(
                  children: [
                    // Notice Body
                    _NoticeBody(noticeId: widget.noticeId, userId: widget.user.userId),
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
      bottomNavigationBar: BottomAppBar(),
    );
  }

  void setReplyTo(int index) {
    setState(() {
      _selectedIdx =
      (_selectedIdx == index) ? Comment.commentWithNoParent : index;
    });
  }

  @override
  void dispose() {
    _commentEditor.dispose();
    super.dispose();
  }

  Widget _commentList() {
    return FutureBuilder(
      future: futureComments,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          comments = snapshot.data!;

          return Column(
            children: [
              for (int i = 0; i < comments.length; ++i)
                CommentWidget(comment: comments[i], index: i,
                    isSelected: (_selectedIdx == i), onTap: setReplyTo),
            ]
          );
        }

        return const CircularProgressIndicator();
      }
    );
  }

  Widget _writingCommentBox() {
    return Container(
      padding: Design.edge10,
      child: TextField(
        minLines: 1, maxLines: 5,
        style: TextStyles.bodyMedium,
        textAlign: TextAlign.justify,
        controller: _commentEditor,

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

  bool _checkValidate() {
    if (_commentEditor.text.isEmpty) {
      Toast.showToast(_commentHintMessage);
      return false;
    }
    return true;
  }

  void _writeComment() {
    int? parentCommentId = (_selectedIdx != Comment.commentWithNoParent)? comments[_selectedIdx].commentId : null;
    Future<int> result = Comment.writeComment(
        widget.user.userId, widget.noticeId, _commentEditor.text, parentCommentId);

    result.then((newCommentId) {
      if (newCommentId != Comment.commentCreationError) {
        setState(() {
          _commentEditor.text = "";
          futureComments = Comment.getComments(widget.noticeId);
          _selectedIdx = Comment.commentWithNoParent;
        });
      }
      else {
        Toast.showToast(_writingFailMessage);
      }
    });
  }
}

class _NoticeBody extends StatelessWidget {
  late Future<Notice> futureNotice;

  _NoticeBody({
    super.key,
    required int noticeId,
    required int userId }) {
    futureNotice = Notice.getNotice(noticeId, userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureNotice,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Notice notice = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Title
              SelectableText(notice.title,
                style: TextStyles.titleMedium,),
              Design.padding5,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(TimeUtility.timeToString(notice.createDate),
                    style: TextStyles.bodySmall,),
                  Text('작성자 | ${notice.writerNickname ?? "익명"}',
                    style: TextStyles.bodySmall,),
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
                  Row (
                    children : [
                      Icon(Icons.comment, size: 18,),
                      Design.padding5,
                      Text('${notice.commentCount}'),
                      Design.padding5
                    ]
                  )
                ]
              ),
            ],
          );
        }
        return const CircularProgressIndicator(); //< FXIME
      },
    );
  }
}