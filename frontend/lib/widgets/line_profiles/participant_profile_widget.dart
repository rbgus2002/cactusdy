
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_study_app/models/study_Info.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/routes/round_detail_route.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/outlined_primary_button.dart';
import 'package:group_study_app/widgets/buttons/squircle_widget.dart';
import 'package:group_study_app/widgets/profile_images.dart';
import 'package:group_study_app/widgets/tags/rectangle_tag.dart';
import 'package:group_study_app/widgets/tags/rounded_tag.dart';

class ParticipantProfileWidget extends StatelessWidget {
  static const double _imageSize = 48;

  final User user;
  final double taskProgress;

  const ParticipantProfileWidget({
    Key? key,
    required this.user,
    required this.taskProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Color progressColor = Util.progressToColor(taskProgress); //< FIXME

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Study Image (Left Part)
        SquircleWidget(
          scale: _imageSize,
          child: (user.picture.isNotEmpty) ?
          CachedNetworkImage(
              imageUrl: user.picture,
              fit: BoxFit.cover) : null,),
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
          onTap: () => noName(context)), //< FIXME
      ],
    );
  }

  void noName(BuildContext context) {
    showModalBottomSheet(
      barrierColor: context.extraColors.barrierColor!,
      backgroundColor: context.extraColors.grey000,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),),),
      context: context,
      builder: (context) {
        return Container(
          height: 256,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Design.padding12,

              // Design Bar
              Center(
                child: Container(
                  width: 100,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.extraColors.grey300,
                    borderRadius: Design.borderRadiusSmall,),),),
              Design.padding32,

              Text(
                context.local.attendanceTag,
                style: TextStyles.head3.copyWith(color: context.extraColors.grey900),),
              Design.padding24,

              Row(
                children: [
                  RoundedTag(
                    width: 60,
                    height: 36,
                    color: context.extraColors.pink!,
                    text: Text(
                      context.local.attend,
                      style: TextStyles.head5.copyWith(color: context.extraColors.grey600),),
                    onTap: () {},),
                  Design.padding16,

                  RoundedTag(
                    width: 60,
                    height: 36,
                    color: context.extraColors.green!,
                    text: Text(
                      context.local.late,
                      style: TextStyles.head5.copyWith(color: context.extraColors.grey600),),
                    onTap: () {},),
                  Design.padding16,

                  RoundedTag(
                    width: 60,
                    height: 36,
                    color: context.extraColors.mint!,
                    text: Text(
                      context.local.absent,
                      style: TextStyles.head5.copyWith(color: context.extraColors.grey600),),
                    onTap: () {},),
                ],),
              Design.padding24,

              OutlinedPrimaryButton(
                text: context.local.confirm,
                onPressed: () => Util.popRoute(context),),],
          ),
        );


      },);
  }
}