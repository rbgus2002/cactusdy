import 'package:flutter/material.dart';
import 'package:group_study_app/models/comment.dart';
import 'package:group_study_app/models/notice.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/widgets/comment_widget.dart';
import 'package:intl/intl.dart';

class NoticeDetailRoute extends StatefulWidget {
  late final NoticeTmp notice;

  NoticeDetailRoute() {
    User user = User(userId: 20182426, nickName: "Arkady", image: "");

    notice = NoticeTmp(
        noticeId: 123,
        title: "[공지] 내일 늦게 오는 사람 커피 사기;; 그런데 만약 좀더 긴 이름의 제목이면?",
        content: "아니 요즘 정시에 오는 사람이 없음 ㅋㅋㅋㅋㅋ 고로 다음 스터디인 내일부터 늦게 오는 사람이 커피사는 걸로 합시다!! 반박시 이완용",
        writer: user,
        writingTime: DateTime.now(),
    );
  }

  @override
  State<StatefulWidget> createState() {
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

              // line


              SelectableText(
                widget.notice.content,
                style: TextStyles.bodyLarge,
                textAlign: TextAlign.justify,
              ),

              Design.padding15,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('yyyy-MM-dd').format(widget.notice.writingTime?? DateTime.now()),
                    style: TextStyles.bodyMedium,),
                  Text("작성자 : ${widget.notice.writer.nickName??"익명"}",
                    style: TextStyles.bodyMedium,),
                ],
              ),

              CommentWidget(
                comment: Comment(writer: User(userId: 1, nickName:  "Arkady", image:  "asd"), writingTime: DateTime.now(), content: "ㅋㅋㅋ 말이 되는 소리좀 하십시오 제발 ㅋㅋㅋ 사람들이 일직 오겠냐고 !!!"),
              )
            ],
          ),
        ),
      )
    );
  }
}