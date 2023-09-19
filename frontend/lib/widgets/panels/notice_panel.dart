import 'package:flutter/material.dart';
import 'package:group_study_app/models/notice_summary.dart';
import 'package:group_study_app/routes/notice_detail_route.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/widgets/panels/panel.dart';
import 'package:intl/intl.dart';

class NoticePanel extends StatefulWidget {
  final NoticeSummary noticeSummary;

  const NoticePanel({
    super.key,
    required this.noticeSummary,
  });

  @override
  State<NoticePanel> createState() => _NoticePanel();
}

class _NoticePanel extends State<NoticePanel> {
  void _switchPin() async {
    // Fast Unsafe State Update
    setState(() { widget.noticeSummary.pinYn = !widget.noticeSummary.pinYn; } );

    // Call API and Verify State
    NoticeSummary.switchNoticePin(widget.noticeSummary.noticeId).then((pinYn) =>
      setState(() { widget.noticeSummary.pinYn = pinYn; })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Panel(
        boxShadows: Design.basicShadows,
        child: InkWell(child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child:
                  Text(widget.noticeSummary.title,
                    style: TextStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.push_pin_sharp, size: 20,),
                  color: (widget.noticeSummary.pinYn) ? null : ColorStyles.lightGrey,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: _switchPin,
                )
              ],
            ),

            Design.padding15,
            Text(widget.noticeSummary.contents,
              textAlign: TextAlign.justify,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            Design.padding15,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(TimeUtility.getElapsedTime(widget.noticeSummary.createDate)),
                Text("작성자 : ${widget.noticeSummary.writerNickname ?? "익명"}"),
              ],
            )
          ],
        ),
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NoticeDetailRoute(noticeId: widget.noticeSummary.noticeId))
            )
          },
        )
    );
  }
}