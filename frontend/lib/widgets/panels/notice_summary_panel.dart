import 'package:flutter/material.dart';
import 'package:group_study_app/models/notice_summary.dart';
import 'package:group_study_app/routes/notices/notice_list_route.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/old_text_styles.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/util.dart';

class NoticeSummaryPanel extends StatelessWidget {
  static const int _length = 3;

  late Future<List<NoticeSummary>> noticeSummaries;
  final int studyId;

  List<String> contents = List<String>.filled(_length, "");

  NoticeSummaryPanel({
    Key? key,
    required this.studyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Util.pushRoute(context, (context) =>
          NoticeListRoute(studyId: studyId)),
      child: Container(
        alignment: Alignment.centerLeft,
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),

        decoration: BoxDecoration(
          color: context.extraColors.inputFieldBackgroundColor,
          borderRadius: Design.borderRadiusSmall,
        ),
        child: FutureBuilder(
          future: NoticeSummary.getNoticeSummaryList(studyId, 0, 3),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              for (int i = 0; i < snapshot.data!.length; ++i) {
                contents[i] = snapshot.data![i].title;
              }

              return Text(
                '• ${contents[0]}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.body1.copyWith(
                    color: context.extraColors.grey700),
              );

              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  for (var content in contents)
                    Text('• $content', style: OldTextStyles.bodyLarge,
                      maxLines: 1, overflow: TextOverflow.ellipsis,),
                ]
              );
            }
            else {
              return const SizedBox();
            }
          }
        ),
      ),
    );
  }
}