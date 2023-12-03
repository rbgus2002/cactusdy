
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_study_app/models/study_Info.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/routes/round_detail_route.dart';
import 'package:group_study_app/routes/profiles/profile_route.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/outlined_primary_button.dart';
import 'package:group_study_app/widgets/buttons/squircle_widget.dart';
import 'package:group_study_app/widgets/dialogs/bottom_sheets.dart';
import 'package:group_study_app/widgets/profile_images.dart';
import 'package:group_study_app/widgets/tags/rectangle_tag.dart';
import 'package:group_study_app/widgets/tags/rounded_tag.dart';

class ParticipantProfileWidget extends StatelessWidget {
  static const double _imageSize = 48;

  final User user;
  final int studyId;
  final double taskProgress;

  const ParticipantProfileWidget({
    Key? key,
    required this.user,
    required this.studyId,
    required this.taskProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Color progressColor = Util.progressToColor(taskProgress); //< FIXME

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Participant Profile Image (Left Part)
        InkWell(
          onTap: () => Util.pushRouteWithSlideDown(context, (context, animation, secondaryAnimation) =>
            ProfileRoute(
                userId: user.userId,
                studyId: studyId),),
          child: SquircleImageWidget(
              scale: _imageSize,
              url: user.profileImage),),
        Design.padding12,

        // User nickname & status message
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nickname
              Text(
                  user.nickname,
                  style: TextStyles.head4.copyWith(color: context.extraColors.grey900)),
              Design.padding4,

              // Task Progress (%)
              Text(
                  '${(taskProgress * 100).toStringAsFixed(1)}%',
                  style: TextStyles.head5.copyWith(color: ColorStyles.mainColor)),
            ],),
        ),
                  // Scheduled Tag
        RoundedTag(
          width: 48,
          height: 30,
          text: Text(
            context.local.reserved,
            style: TextStyles.caption1.copyWith(
              color: context.extraColors.grey700,),),
          color: context.extraColors.pink!,
          onTap: () => BottomSheets.statusTagPickerBottomSheet(
              context: context,
              onChose: (){})),//< FIXME
      ],
    );
  }
}