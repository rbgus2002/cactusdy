import 'dart:math';

import 'package:flutter/material.dart';
import 'package:group_study_app/models/notice.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';
import 'package:group_study_app/widgets/circle_button_list.dart';
import 'package:group_study_app/models/user.dart';

class NoticeReactionTag extends StatefulWidget {
  User user = Test.testUser; //< FIXME

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

  double _width = 0;

  bool _isNeedUpdate = true;
  bool _isExpended = false;

  List<CircleButton> _checkerImages = [];

  void getCheckerImages() async {
    Notice.getCheckUserImageList(widget.noticeId).then(
      (profileURIs) {
        setState(() { _checkerImages = List.generate(profileURIs.length,//< FIXME
                (index) => const CircleButton(child: null)).toList();
        });
      },
    );

    _isNeedUpdate = false;
  }

  void _switchCheck() async {
    // Fast Unsafe State Update
    setState(() {
      widget.isChecked = !widget.isChecked;
      (widget.isChecked)? ++widget.checkerNum: --widget.checkerNum;
    });

    // Call API and Verify State
    Notice.switchCheckNotice(widget.noticeId, widget.user.userId).then((value) {
      if (value != widget.isChecked) {
        (widget.isChecked)? --widget.checkerNum: ++widget.checkerNum;
        widget.isChecked = value;
      }
    });

    _isNeedUpdate = true;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(_boarderRadius),
      onTap: _switchCheck,
      onLongPress: () => {
        setState(() {
          _isExpended = !_isExpended;

          if (_isExpended) {
            if (_isNeedUpdate) { getCheckerImages(); }

            final int showCount = min(widget.checkerNum, _showCountMax);
            _width = _boarderRadius * showCount;
          }

          else { _width = 0; }
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
              padding: const EdgeInsets.fromLTRB(_padding, 0, 0, 0),
              width: _width,
              duration: Duration(seconds: widget.duration),
              curve: Curves.fastOutSlowIn,

              child: CircleButtonList(circleButtons: _checkerImages, paddingVertical: _padding * 2),
            ),

            // checker Num
            Design.padding5,
            Text("${widget.checkerNum}"),
            Design.padding5,
          ]
        ),
      ),
    );
  }
}