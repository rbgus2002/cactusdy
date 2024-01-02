import 'dart:math';

import 'package:flutter/material.dart';
import 'package:groupstudy/models/notice.dart';
import 'package:groupstudy/themes/color_styles.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/animation_setting.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/widgets/buttons/circle_button.dart';

class NoticeReactionTag extends StatefulWidget {
  final Notice notice;
  final bool enabled;

  const NoticeReactionTag({
    Key? key,
    required this.notice,
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
            color: (widget.notice.read) ?
            ColorStyles.mainColor :
            Colors.transparent),
        color: (widget.notice.read) ?
        context.extraColors.inputFieldBackgroundColor :
        context.extraColors.grey100,),

      child: InkWell(
        borderRadius: BorderRadius.circular(_height / 2),
        onTap: (widget.enabled) ? _switchCheck : null,
        onLongPress: (widget.enabled) ? _switchExpend : null,

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              // Check Icon
              Icon(
                CustomIcons.check2,
                size: 16,
                color: (widget.notice.read) ?
                  ColorStyles.mainColor :
                  context.extraColors.grey600),
              Design.padding(2),

              // Checker Num
              Text(
                  "${widget.notice.checkNoticeCount}",
                  style: TextStyles.caption2.copyWith(
                      color: (widget.notice.read) ?
                        ColorStyles.mainColor :
                        context.extraColors.grey600)),
              Design.padding(2),

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
      widget.notice.read = !widget.notice.read;
      (widget.notice.read)? ++widget.notice.checkNoticeCount: --widget.notice.checkNoticeCount;
    });

    // Call API and Verify State
    Notice.switchCheckNotice(widget.notice.noticeId).then((value) {
      if (value != widget.notice.read) {
        setState(() {
          (widget.notice.read)? --widget.notice.checkNoticeCount: ++widget.notice.checkNoticeCount;
          widget.notice.read = value;
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

        final int showCount = min(widget.notice.checkNoticeCount, _showCountMax);
        _checkerImageListWidth = (_imageSize + 4) * showCount - 4; // 4: padding size
      }

      else { _checkerImageListWidth = 0; }
    });
  }

  void _getCheckerImages() async {
    if (_isNeedUpdate) {
      Notice.getCheckUserImageList(widget.notice.noticeId).then((profileURIs) {
        setState(() => _checkerImages = profileURIs);
      },);
    }

    _isNeedUpdate = false;
  }
}