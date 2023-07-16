import 'package:flutter/material.dart';
import 'package:group_study_app/models/comment.dart';
import 'package:group_study_app/models/notice.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/widgets/comment_widget.dart';
import 'package:group_study_app/widgets/tags/notice_reaction_tag.dart';

class NoticeDetailRoute extends StatefulWidget {
  final int noticeId;
  const NoticeDetailRoute({ required this.noticeId });

  @override
  State<NoticeDetailRoute> createState() {
    return _NoticeDetailRoute();
  }
}

class _NoticeDetailRoute extends State<NoticeDetailRoute> {
  static const String _commentHintMessage = "댓글을 입력해 주세요";

  late final Notice notice;
  late List<Comment> comments;

  @override
  void initState() {
    super.initState();
  }

  Widget _noticeBody() {
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
        NoticeReactionTag(noticeId: notice.noticeId, isChecked: false, checkerNum: notice.checkNoticeCount),
        Design.padding15,

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(TimeUtility.timeToString(notice.createDate),
              style: TextStyles.bodyMedium,),
            Text("작성자 : ${notice.writerNickname??"익명"}",
              style: TextStyles.bodyMedium,),
          ],
        ),
      ],
    );
  }

  Widget _comments() {
    return Column(
      children: [
        for (var comment in comments)
          CommentWidget(comment: comment),
      ]
    );
  }

  Widget _writingCommentBox() {
    return Container(
      padding: Design.edge10,
      child: TextField(
        minLines: 1,
        maxLines: 5,

        style: TextStyles.bodyMedium,
        textAlign: TextAlign.justify,

        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: _commentHintMessage,

          suffixIcon: IconButton(
            icon: const Icon(Icons.send, size: 16),
            onPressed: () => true,),
        ),
      ),
    );
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
              child: Container(
                padding: Design.edge10,
                child: Column(
                  children: [
                    FutureBuilder(
                      future: Notice.getNotice(widget.noticeId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          notice = snapshot.data!;
                          return _noticeBody();
                        }

                        return Text("Asd"); //< FIXME
                      },),
                    FutureBuilder(
                      future: Comment.getComments(widget.noticeId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          comments = snapshot.data!;
                          return _comments();
                        }

                        return Text("응 안됌 ㅋㅋ"); //< FIXME
                      }
                    )
                  ]
                ),
              ),
            ),
          ),
          _writingCommentBox(),
        ],
        ),
      bottomNavigationBar: BottomAppBar(),
    );
  }
}