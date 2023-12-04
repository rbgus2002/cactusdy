

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_study_app/models/study_tag.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';

class StudyTagWidget extends StatelessWidget {
  static const double size = 20;

  final StudyTag studyTag;

  const StudyTagWidget({
    Key? key,
    required this.studyTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              border: Border.all(color: context.extraColors.grey300!, width: 1),
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
            style: TextStyles.body2.copyWith(
                color: context.extraColors.grey800),),
        ],
      ),
    );
  }
}