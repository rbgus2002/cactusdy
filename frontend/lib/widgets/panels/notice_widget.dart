import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:intl/intl.dart';

class NoticeWidget extends StatefulWidget {
  String title;
  String content;
  bool fixed;

  DateTime? date;
  String? userId;

  NoticeWidget({
    Key? key,
    required this.title,
    required this.content,

    this.date,
    this.userId,

    this.fixed = false,
  }) : super(key: key);

  @override
  State<NoticeWidget> createState() => _NoticeWidget();
}

class _NoticeWidget extends State<NoticeWidget> {
  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: Test.onTabTest,

        child: Container(
          padding: Design.edge15,
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 10, color: ColorStyles.lightGrey))),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.title, style: TextStyles.titleSmall,),
                  IconButton(
                    icon: Icon(Icons.push_pin_sharp, color: (widget.fixed)?null:ColorStyles.lightGrey,),
                    splashRadius: 16,
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () { setState(() {
                         widget.fixed = !widget.fixed;
                         //< FIXME : 대충 API 호출
                       });},
                  )
                ],
              ),

              Design.padding15,
              Text(widget.content,
                textAlign: TextAlign.justify,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              Design.padding15,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('yyyy-MM-dd').format(widget.date?? DateTime.now())),
                  Text("작성자 : ${widget.userId??"익명"}"),
                ],
              )
            ],
          ),
        )
      )
    );
  }
}