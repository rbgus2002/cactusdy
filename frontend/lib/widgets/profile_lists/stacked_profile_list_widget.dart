
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:groupstudy/models/participant_summary.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/widgets/buttons/circle_button.dart';

/// Stacked Profile Images for Study Profile
/// it will show Member of Study about [_showingMaxCount]
/// if member count is over [_showingMaxCount], it will show '+' icon also
class StackedProfileListWidget extends StatelessWidget {
  static const double _imageSize = 26;
  static const double _overlaySize = 8;
  static const int _showingMaxCount = 5;

  final List<String> profileImages;

  const StackedProfileListWidget({
    required this.profileImages,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int showingCount = min(_showingMaxCount, profileImages.length);

    return SizedBox(
      height: _imageSize,
      width: (_imageSize - _overlaySize) * showingCount + _overlaySize,
      child: Stack(
        children: [
          for (int i = 0; i < showingCount; ++i)
            Positioned(
              left: (_imageSize - _overlaySize) * i,
              child: CircleButton(
                size: _imageSize,
                url: profileImages[i],),),

          // Excess Number
          if (profileImages.length > _showingMaxCount)
            Positioned(
              right: 0,
              child: Container(
                width: _imageSize,
                height: _imageSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.extraColors.grey000!,
                    width: 1.5),
                  color: Colors.black.withOpacity(0.3),),
                child: Text(
                  '+${profileImages.length - showingCount}',
                  style: TextStyles.caption2.copyWith(color: Colors.white),),),
            ),
        ],),
    );
  }
}
