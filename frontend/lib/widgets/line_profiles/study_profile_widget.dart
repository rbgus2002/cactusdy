
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:groupstudy/models/study.dart';
import 'package:groupstudy/routes/round_detail_route.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/color_util.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/time_utility.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/profile_lists/stacked_profile_list_widget.dart';
import 'package:groupstudy/widgets/tags/rectangle_tag.dart';

class StudyProfileWidget extends StatelessWidget {
  final StudySummary studyInfo;
  final Function onRefresh;

  const StudyProfileWidget({
    super.key,
    required this.studyInfo,
    required this.onRefresh,
  });

  static const double _imageSize = 88;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Study Image (Left Part)
        Container(
          width: _imageSize,
          height: _imageSize,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: ColorUtil.addColor(studyInfo.study.color, context.extraColors.grey000!, 0.4),
            borderRadius: BorderRadius.circular(Design.radiusValue),),
          child: (studyInfo.study.picture.isNotEmpty) ?
              CachedNetworkImage(
                imageUrl: studyInfo.study.picture,
                fit: BoxFit.cover) : null,),
        Design.padding16,

        // Study Information (Right Part)
        Flexible(
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Study Name
              Text(
                studyInfo.study.studyName,
                style: TextStyles.head4.copyWith(color: context.extraColors.grey900),
                overflow: TextOverflow.ellipsis),
              Design.padding4,

              // Study Place & Date
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  _getPlaceAndTimeText(context),
                  style: TextStyles.body2.copyWith(color: context.extraColors.grey600),),),
              Design.padding16,

              // Round Info & Participants
              Row(
                children: [
                  // Round Sequence Tag
                  _roundSequenceTag(context),
                  Design.padding4,

                  // Scheduled Tag
                  _scheduledTag(context),
                  const Spacer(),

                  StackedProfileListWidget(profileImages: studyInfo.profileImages),
                ],)
            ],),
        )],
    );
  }

  Widget _roundSequenceTag(BuildContext context) {
    return Visibility(
      visible: _isRoundIdNotZero(),
      child: RectangleTag(
        width: 48,
        height: 26,
        text: Text(
          '${studyInfo.roundSeq}${context.local.round}',
          style: TextStyle(
            height: 1.1,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: context.extraColors.grey700,),),
        color: studyInfo.study.color.withOpacity(0.3),
        onTap: () => Util.pushRoute(context, (context) =>
            RoundDetailRoute(
              roundSeq: studyInfo.roundSeq,
              round: studyInfo.round,
              study: studyInfo.study,),)
          .then((value) => onRefresh()),
      ),
    );
  }

  Widget _scheduledTag(BuildContext context) {
    return Visibility(
      visible: TimeUtility.isScheduled(studyInfo.round.studyTime),
      child: RectangleTag(
        width: 40,
        height: 26,
        text: Text(
          context.local.scheduled,
          style: TextStyles.caption1.copyWith(
            height: 1.1,
            color: context.extraColors.grey800,),),
        color: context.extraColors.pink!,
        onTap: () => Util.pushRoute(context, (context) =>
            RoundDetailRoute(
              roundSeq: studyInfo.roundSeq,
              round: studyInfo.round,
              study: studyInfo.study,),)
          .then((value) => onRefresh()),
      ),
    );
  }

  String _getPlaceAndTimeText(BuildContext context) {
    String timeText = (studyInfo.round.studyTime != null) ?
      TimeUtility.timeToString(studyInfo.round.studyTime!) :
      context.local.undefinedOf(context.local.time);

    String placeText = (studyInfo.round.studyPlace.isNotEmpty) ?
      studyInfo.round.studyPlace :
      context.local.undefinedOf(context.local.place);

    return '$timeText • $placeText';
  }

  bool _isRoundIdNotZero() {
    return studyInfo.roundSeq != 0;
  }
}