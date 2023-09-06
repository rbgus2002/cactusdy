

import 'package:flutter/material.dart';
import 'package:group_study_app/models/notice.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/widgets/tags/notice_reaction_tag.dart';

class NoticeBody extends StatelessWidget {
  late Future<Notice> futureNotice;
  final int noticeId;
  final User user = Test.testUser; //< FIXME


  NoticeBody({
    super.key,
    required this.noticeId,
  });

  @override
  Widget build(BuildContext context) {
    //futureNotice = Notice.getNoticeFake(noticeId, user.userId);

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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      //onTap: _focusNode.requestFocus, <FIXME !!!
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

        return Design.loadingIndicator;
      },
    );
  }
}