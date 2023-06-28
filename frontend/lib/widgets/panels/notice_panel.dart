import 'package:flutter/material.dart';
import 'package:group_study_app/models/notice_summary.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/widgets/panels/panel.dart';
import 'package:intl/intl.dart';

class NoticePanel extends StatefulWidget {
  final NoticeSummary noticeSummary;

  NoticePanel({
    Key? key,
    required this.noticeSummary,
  }) : super(key: key);

  @override
  State<NoticePanel> createState() => _NoticePanel();
}

class _NoticePanel extends State<NoticePanel> {
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
              Text(widget.noticeSummary.title, style: TextStyles.titleSmall,),
              IconButton(
                icon: Icon(Icons.push_pin_sharp, color: (widget.noticeSummary.pinYn)?null:ColorStyles.lightGrey,),
                splashRadius: 16,
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () { setState(() {
                     widget.noticeSummary.pinYn = !widget.noticeSummary.pinYn;
                     //< FIXME : 대충 API 호출
                   });},
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
              Text(TimeUtility.timeToString(widget.noticeSummary.createDate)),
              Text("작성자 : ${widget.noticeSummary.writerNickname??"익명"}"),
            ],
          )
        ],
      ))
    );
  }
}