import 'dart:math';

import 'package:flutter/material.dart';
import 'package:group_study_app/models/notice.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/user_list_button.dart';
import 'package:group_study_app/models/user.dart';

class NoticeReactionTag extends StatefulWidget {
  User user = Test.testUser;

  final int noticeId;
  final int duration;
  int checkerNum;
  bool isChecked;

  NoticeReactionTag({
    Key? key,
    required this.noticeId,
    required this.isChecked,
    required this.checkerNum,
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

  late List<User>

  double _width = 0;

  bool _isNeedUpdate = false;

  void _switchCheck() async {
    // Fast Unsafe State Update
    setState(() {
      widget.isChecked = !widget.isChecked;
      if (widget.isChecked) ++widget.checkerNum;
      else --widget.checkerNum;

      _isNeedUpdate = true;
    });

    // Call API and Verify State
    Notice.switchCheckNotice(widget.noticeId, widget.user.userId);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(_boarderRadius),
      onTap: _switchCheck,
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
        padding: const EdgeInsets.all(_padding),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Check Icon
            Icon(Icons.check_circle, color: (widget.isChecked)? ColorStyles.green : ColorStyles.darkGrey),

            // User List
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

            // checker Num
            Text("${widget.checkerNum}"),
            Design.padding5,
          ]
        ),
      ),
    );
  }
}