import 'dart:async';

import 'package:flutter/material.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';

class AutoScrollingBanner extends StatefulWidget {
  final List<String> contents;
  final String hintText;

  const AutoScrollingBanner({
    Key? key,
    required this.contents,
    required this.hintText,
  }) : super(key: key);

  @override
  State<AutoScrollingBanner> createState() => _AutoScrollingBannerState();
}

class _AutoScrollingBannerState extends State<AutoScrollingBanner> {
  static const int exposureTime = 4;
  static const double _textHeight = 20;

  final ScrollController _scrollController = ScrollController();

  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (!_isScrolling()) {
      _startScroll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return (widget.contents.isEmpty) ?
        // #Case Empty : Hint Text
        Text(
          widget.hintText,
          style: TextStyles.body1.copyWith(
              color: context.extraColors.grey400),) :
        // #Case Else : Text Auto Scroller
        SizedBox(
          height: _textHeight,
          child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            controller: _scrollController,
            itemCount: widget.contents.length,
            itemBuilder: (context, index) =>
                Text(
                  widget.contents[index % widget.contents.length],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.body1.copyWith(
                      color: context.extraColors.grey700),),),
        );
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    super.dispose();
  }

  void _startScroll() {
    if (widget.contents.isNotEmpty) {
      _timer = Timer.periodic(const Duration(seconds: exposureTime), (timer) {
        if (++_currentIndex >= widget.contents.length) {
          _currentIndex = 0;
        }

        if (_scrollController.hasClients) {
          // animate to index
          _scrollController.animateTo(
              _currentIndex * _textHeight,
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut);
        }
      });
    }
  }

  bool _isScrolling() {
    return (_timer != null);
  }
}