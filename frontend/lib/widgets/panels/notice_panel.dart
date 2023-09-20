import 'dart:math';

import 'package:flutter/material.dart';
import 'package:group_study_app/models/notice_summary.dart';
import 'package:group_study_app/routes/notice_detail_route.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/animation_setting.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/widgets/panels/panel.dart';
import 'package:group_study_app/widgets/tags/notice_reaction_tag.dart';
import 'package:intl/intl.dart';

class NoticePanel extends StatefulWidget {
  final NoticeSummary noticeSummary;

  NoticePanel({
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

            // Writing Info
            Design.padding5,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(TimeUtility.getElapsedTime(widget.noticeSummary.createDate)),
                Text("작성자 : ${widget.noticeSummary.writerNickname ?? "익명"}"),
              ],
            ),

            // Notice Summary Body
            Design.padding10,
            Text(widget.noticeSummary.contents,
              textAlign: TextAlign.justify,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            // Reaction Tag
            Design.padding10,
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: Test.onTabTest,
                      child: Row(
                        children: [
                          // Check Icon
                          Icon(Icons.check_circle, color: (widget.noticeSummary.read)? ColorStyles.green : ColorStyles.darkGrey, size: 20,),
                          Design.padding3,
                          Text('${widget.noticeSummary.readCount}'), //< FIXME
                        ],
                      ),
                  ),

                  Row(
                    children: [
                      const Icon(Icons.comment, size: 18,),
                      Design.padding5,
                      Text('${widget.noticeSummary.commentCount}'),
                      Design.padding5
                    ]
                  )
                ]
            ),
          ],
        ),
        ),

      onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoticeDetailRoute(noticeId: widget.noticeSummary.noticeId))
      ); },
    );
  }
}