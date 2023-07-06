import 'dart:math';

import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/Tags/tag_button.dart';
import 'package:group_study_app/widgets/user_list_button.dart';

class NoticeReactionTag extends StatefulWidget {
  final double studyId;
  final int checkerNum;
  final int duration;

  bool isChecked;

  NoticeReactionTag({
    Key? key,
    required this.studyId,
    required this.isChecked,
    this.checkerNum = 5,
    this.duration = 1,
  }) : super(key: key);

  @override
  State<NoticeReactionTag> createState() => _NoticeReactionTag();
}

class _NoticeReactionTag extends State<NoticeReactionTag> {
  static const double _height = 21;
  static const double _padding = 2;
  static const double _boarderRadius = _height + 2 * _padding;
  static const int _showCountMax = 5;

  double _width = 0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(_boarderRadius),
      onTap: () => {
        setState(() {
          //< FIXME : 대충 버튼 API호출
          widget.isChecked = !widget.isChecked;
        })
      },
      onLongPress: () => {
        setState(() {
          final int showCount = min(widget.checkerNum, _showCountMax);
          _width = (_width != 0)? 0 : _boarderRadius * showCount;
        })
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_boarderRadius),
          color: ColorStyles.grey,
        ),
        padding: EdgeInsets.all(_padding),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: (widget.isChecked)?ColorStyles.green : ColorStyles.darkGrey,),

            AnimatedContainer(
              width: _width,
              duration: Duration(seconds: widget.duration),
              curve: Curves.fastOutSlowIn,

              child: UserListButton(
                scale: _height,
                userList: Test.testUserList ,
              ),
            ),
            Design.padding5,
            Text("${widget.checkerNum}"),
            Design.padding5,
          ]
        ),
      ),
    );
  }
}