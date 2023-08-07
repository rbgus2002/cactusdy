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
  int checkerNum;
  bool isChecked;

  NoticeReactionTag({
    Key? key,
    required this.noticeId,
    required this.isChecked,
    required this.checkerNum,
  }) : super(key: key);

  @override
  State<NoticeReactionTag> createState() => _NoticeReactionTag();
}

class _NoticeReactionTag extends State<NoticeReactionTag> {
  static const double _height = 21;
  static const double _padding = 2;
  static const double _boarderRadius = _height + 2 * _padding;
  static const int _showCountMax = 5;
  static const int _duration = 1;

  List<CircleButton> _checkerImages = [];
  double _width = 0;
  bool _isNeedUpdate = true;
  bool _isExpended = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(_boarderRadius),
      onTap: _switchCheck,
      onLongPress: _switchExpend,

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
              duration: Duration(seconds: _duration),
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

  void _switchExpend() {
    setState(() {
      _isExpended = !_isExpended;

      if (_isExpended) {
        _getCheckerImages();

        final int showCount = min(widget.checkerNum, _showCountMax);
        _width = _boarderRadius * showCount;
      }

      else { _width = 0; }
    });
  }

  void _getCheckerImages() async {
    if (_isNeedUpdate) {
      Notice.getCheckUserImageList(widget.noticeId).then((profileURIs) {
        setState(() {
          _checkerImages = List.generate(profileURIs.length, //< FIXME
                  (index) => const CircleButton(child: null)).toList();
        });
      },);
    }

    _isNeedUpdate = false;
  }
}