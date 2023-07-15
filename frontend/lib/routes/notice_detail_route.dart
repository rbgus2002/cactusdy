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
  NoticeDetailRoute({ required this.noticeId }) {
    User user = User(userId: 20182426, nickname: "Arkady", statusMessage: "", picture: "");

    /*
    notice = Notice(
        noticeId: 123,
        title: "[공지] 내일 늦게 오는 사람 커피 사기;; 그런데 만약 좀더 긴 이름의 제목이면?",
        content: "아니 요즘 정시에 오는 사람이 없음 ㅋㅋㅋㅋㅋ 고로 다음 스터디인 내일부터 늦게 오는 사람이 커피사는 걸로 합시다!! 반박시 이완용",
        writerNickname: "Arkady",
        checkNoticeCount: 1,
        createDate: DateTime.now(),
    );
     */
  }

  @override
  State<NoticeDetailRoute> createState() {
    return _NoticeDetailRoute();
  }
}

class _NoticeDetailRoute extends State<NoticeDetailRoute> {
  static const String _commentHintMessage = "댓글을 입력해 주세요";

  late final Notice notice;

  @override
  void initState() {
    super.initState();
  }

  Widget _noticeBody() {
    return SingleChildScrollView(
      child: Container(
        padding: Design.edge15,
        child : Column(
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
            Design.padding15,

            CommentWidget(
              comment: Comment(writer: Test.testUser, writingTime: DateTime.now(), content: "혹시 두 명 이상이 늦으면 커피 두잔씩 마시는 건가요?",),
              replies: [
                Comment(writer: User(userId: 1, nickname:  "규규", picture:  "asd", statusMessage: "asdas"), writingTime: DateTime.now(), content: "겠냐고 ㅋㅋㅋㅋ 늦을 생각 자체를 하지마",),
                Comment(writer: User(userId: 1, nickname:  "Arkady", picture:  "asd", statusMessage: "asdas"), writingTime: DateTime.now(), content: "우리 저렴한 커피 나무로 갈까 ^_^ 아 근데 진짜 확실한 건 예지 누나는 이미 지각인 듯"),
              ],
            )
          ],
        ),
      ),
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
              child: FutureBuilder(
                future: Notice.getNotice(widget.noticeId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    notice = snapshot.data!;
                    return _noticeBody();
                  }
                  else
                    return Text("Asd");
                },
              )
            ),
            _writingCommentBox(),
          ],
        ),
      bottomNavigationBar: BottomAppBar(),
    );
  }
}