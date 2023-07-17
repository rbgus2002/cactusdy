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
  static const String _wrtingFailMessage = "작성에 실패했습니다";

  late final _commentEditer = TextEditingController();
  late Future<Notice> futureNotice;

  int _replyTo = -1;

  @override
  void initState() {
    super.initState();
    futureNotice = Notice.getNotice(widget.noticeId, widget.user.userId);
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
                    // Nootice Body
                    _noticeBody(),
                    Design.padding15,

                    // Comments
                    _commentListWidget(),
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
    _commentEditer.dispose();
    super.dispose();
  }

  Widget _noticeBody() {
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
              Design.padding15,

              // Body
              SelectableText(notice.contents,
                style: TextStyles.bodyLarge,
                textAlign: TextAlign.justify,),
              Design.padding15,

              // Reaction Tag
              NoticeReactionTag(noticeId: notice.noticeId,
                  isChecked: notice.read,
                  checkerNum: notice.checkNoticeCount),
              Design.padding15,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(TimeUtility.timeToString(notice.createDate),
                    style: TextStyles.bodyMedium,),
                  Text("작성자 : ${notice.writerNickname ?? "익명"}",
                    style: TextStyles.bodyMedium,),
                ],
              ),
            ],
          );
        }
        return Text("Asd"); //< FIXME
      },
    );
  }

  Widget _commentListWidget() {
    return FutureBuilder(
      future: Comment.getComments(widget.noticeId),
      builder: (context, comments) {
        if (comments.hasData) {
          return Column(
            children: [
              for (var comment in comments.data!)
                CommentWidget(comment: comment),
            ]
          );
        }

        return Text("응 안됌 ㅋㅋ"); //< FIXME
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
        controller: _commentEditer,

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
    if (_commentEditer.text.isEmpty) {
      Toast.showToast(_commentHintMessage);
      return false;
    }
    return true;
  }

  void _writeComment() {
    Future<int> result = Notice.writeComment(
        widget.user.userId, widget.noticeId, _commentEditer.text, _replyTo);

    result.then((newCommentId) {
      if (newCommentId != Notice.COMMENT_CREATION_ERROR) {
        setState(() {
          _commentEditer.text = "";
          _replyTo = -1;
        });
      }
      else {
        Toast.showToast(_wrtingFailMessage);
      }
    });
  }
}