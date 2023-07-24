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

/*
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

  late Future<Notice> futureNotice;
  late Future<List<Comment>> futureComments;

  late List<Comment> comments;

  @override
  void initState() {
    super.initState();
    futureNotice = Notice.getNotice(widget.noticeId, widget.user.userId);
    futureComments = Comment.getComments(widget.noticeId);
  }

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
                    _noticeBody(),
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


  @override
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
                style: TextStyles.titleMedium,
                textAlign: TextAlign.justify,
              ),
              Design.padding5,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(TimeUtility.timeToString(notice.createDate),
                    style: TextStyles.bodySmall,),
                  Text('작성자 : ${notice.writerNickname ?? "익명"}',
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

                  InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    onTap: _focusNode.requestFocus,
                    child: Row (
                      children : [
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

        return const SizedBox(
          height: 128,
          child: Center(
            child: CircularProgressIndicator()
          )
        );//< FXIME
      },
    );
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
              child: const Text(_cancelMessage),),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteNotice();
              },
              child: const Text(_checkMessage),),
          ],
        )
    ));
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
}

 */