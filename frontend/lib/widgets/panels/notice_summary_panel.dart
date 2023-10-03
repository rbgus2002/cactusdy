import 'package:flutter/material.dart';
import 'package:group_study_app/models/notice.dart';
import 'package:group_study_app/models/notice_summary.dart';
import 'package:group_study_app/models/sign_info.dart';
import 'package:group_study_app/routes/notice_detail_route.dart';
import 'package:group_study_app/routes/notice_list_route.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';

class NoticeSummaryPanel extends StatelessWidget {
  static const int _length = 3;

  late Future<List<NoticeSummary>> noticeSummaries;
  final int noticeId;

  List<String> contents = List<String>.filled(_length, "");

  NoticeSummaryPanel({
    super.key,
    required this.noticeId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 105,

      color: ColorStyles.lightGrey,
      padding: Design.edge15,

      child: InkWell(
        onTap: () => Navigator.push( context,
            MaterialPageRoute(builder: (context) => NoticeListRoute()),
        ),
        child: FutureBuilder(
          future: NoticeSummary.getNoticeSummaryListLimit3(noticeId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              for (int i = 0; i < snapshot.data!.length; ++i) {
                contents[i] = snapshot.data![i].title;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  for (var content in contents)
                    Text('• $content', style: TextStyles.bodyLarge,
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