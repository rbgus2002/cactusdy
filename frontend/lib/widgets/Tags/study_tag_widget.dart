

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:groupstudy/models/study_tag.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/color_util.dart';
import 'package:groupstudy/utilities/extensions.dart';

class StudyTagWidget extends StatelessWidget {
  static const double size = 20;

  final StudyTag studyTag;

  const StudyTagWidget({
    super.key,
    required this.studyTag,
  });

  @override
  Widget build(BuildContext context) {
    bool bright = ColorUtil.isBright(studyTag.studyColor);

    return Container(
      height: 36,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: studyTag.studyColor,
        borderRadius: Design.borderRadiusSmall,),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Study Image (Left Part)
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
                width: 1),
              borderRadius: BorderRadius.circular(Design.radiusValueSmall + 0.5),),
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Design.radiusValueSmall),),

              child: (studyTag.studyProfileImage.isNotEmpty) ?
                CachedNetworkImage(
                    imageUrl: studyTag.studyProfileImage,
                    fit: BoxFit.cover) : null,
            ),),
          Design.padding8,

          Text(
            studyTag.studyName,
            style: TextStyles.head6.copyWith(
                color: (bright)?
                  Colors.black87 :
                  Colors.white),),
        ],
      ),
    );
  }
}