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
import 'package:intl/intl.dart';

class NoticeDetailRoute extends StatefulWidget {
  late final Notice notice;

  NoticeDetailRoute(int noticeId) {
    User user = User(userId: 20182426, nickName: "Arkady", statusMessage: "", picture: "");

    notice = Notice(
        noticeId: 123,
        title: "[공지] 내일 늦게 오는 사람 커피 사기;; 그런데 만약 좀더 긴 이름의 제목이면?",
        content: "아니 요즘 정시에 오는 사람이 없음 ㅋㅋㅋㅋㅋ 고로 다음 스터디인 내일부터 늦게 오는 사람이 커피사는 걸로 합시다!! 반박시 이완용",
        writer: user,
        writingTime: DateTime.now(),
    );
  }

  @override
  State<NoticeDetailRoute> createState() {
    return _NoticeDetailRoute();
  }
}

class _NoticeDetailRoute extends State<NoticeDetailRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.white10,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: Design.edge15,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Title & Writer
              Text(widget.notice.title, style: TextStyles.titleMedium,),
              Design.padding15,

              SelectableText(
                widget.notice.content,
                style: TextStyles.bodyLarge,
                textAlign: TextAlign.justify,
              ),

              Design.padding15,
              NoticeReactionTag(studyId: 1, isChecked: false,),

              Design.padding15,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(TimeUtility.timeToString(widget.notice.writingTime),
                    style: TextStyles.bodyMedium,),
                  Text("작성자 : ${widget.notice.writer.nickName??"익명"}",
                    style: TextStyles.bodyMedium,),
                ],
              ),

              Design.padding15,
              CommentWidget(
                comment: Comment(writer: Test.testUser, writingTime: DateTime.now(), content: "혹시 두 명 이상이 늦으면 커피 두잔씩 마시는 건가요?",),
                replies: [
                  Comment(writer: User(userId: 1, nickName:  "규규", picture:  "asd", statusMessage: "asdas"), writingTime: DateTime.now(), content: "겠냐고 ㅋㅋㅋㅋ 늦을 생각 자체를 하지마",),
                  Comment(writer: User(userId: 1, nickName:  "Arkady", picture:  "asd", statusMessage: "asdas"), writingTime: DateTime.now(), content: "우리 저렴한 커피 나무로 갈까 ^_^ 아 근데 진짜 확실한 건 예지 누나는 이미 지각인 듯"),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}