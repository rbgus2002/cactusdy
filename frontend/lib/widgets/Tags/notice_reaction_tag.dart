import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_study_app/models/notice.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/animation_setting.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';

class NoticeReactionTag extends StatefulWidget {
  final int noticeId;
  final bool enabled;
  int checkerNum;
  bool isChecked;

  NoticeReactionTag({
    Key? key,
    required this.noticeId,
    required this.isChecked,
    required this.checkerNum,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<NoticeReactionTag> createState() => _NoticeReactionTag();
}

class _NoticeReactionTag extends State<NoticeReactionTag> {
  // Widget options
  static const double _height = 24;

  // Checker profile images options
  static const double _imageSize = 16;
  static const int _showCountMax = 5;

  List<String> _checkerImages = [];
  double _checkerImageListWidth = 0;

  bool _isNeedUpdate = true;
  bool _isExpended = false;

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: _height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_height / 2),
        border: Border.all(
            color: (widget.isChecked) ?
            ColorStyles.mainColor :
            Colors.transparent),
        color: (widget.isChecked) ?
        context.extraColors.inputFieldBackgroundColor :
        context.extraColors.grey100,),

      child: InkWell(
        borderRadius: BorderRadius.circular(_height / 2),
        onTap: (widget.enabled) ? _switchCheck : null,
        onLongPress: (widget.enabled) ? _switchExpend : null,

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              // Check Icon
              Icon(
                  CustomIcons.check,
                  size: 14,
                  color: (widget.isChecked) ?
                    ColorStyles.mainColor :
                    context.extraColors.grey600),
              Design.padding(2),

              // Checker Num
              Text(
                  "${widget.checkerNum}",
                  style: TextStyles.caption2.copyWith(
                      color: (widget.isChecked) ?
                        ColorStyles.mainColor :
                        context.extraColors.grey600)),
              Design.padding4,

              // User List
              AnimatedContainer(
                width: _checkerImageListWidth,
                duration: AnimationSetting.animationDuration,
                curve: Curves.fastOutSlowIn,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _checkerImages.length,
                  itemBuilder: (context, index) =>
                      CircleButton(
                        url: _checkerImages[index],
                        size: _imageSize,
                        borderWidth: 0,),
                  separatorBuilder: (context, index) =>
                      Design.padding4,),
              ),
            ]),
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
    Notice.switchCheckNotice(widget.noticeId).then((value) {
      if (value != widget.isChecked) {
        setState(() {
          (widget.isChecked)? --widget.checkerNum: ++widget.checkerNum;
          widget.isChecked = value;
        });
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
        _checkerImageListWidth = (_imageSize + 4) * showCount - 4; // 4: padding size
      }

      else { _checkerImageListWidth = 0; }
    });
  }

  void _getCheckerImages() async {
    if (_isNeedUpdate) {
      Notice.getCheckUserImageList(widget.noticeId).then((profileURIs) {
        setState(() => _checkerImages = profileURIs);
      },);
    }

    _isNeedUpdate = false;
  }
}