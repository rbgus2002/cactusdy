
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:groupstudy/models/study_Info.dart';
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
  static const double _imageSize = 88;

  final StudyInfo studyInfo;
  final Function onRefresh;

  const StudyProfileWidget({
    Key? key,
    required this.studyInfo,
    required this.onRefresh,
  }) : super(key: key);

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
                  Visibility(
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
                      color: context.extraColors.blue!,
                      onTap: () => Util.pushRoute(context, (context) =>
                          RoundDetailRoute(
                              roundSeq: studyInfo.roundSeq,
                              roundId: studyInfo.round.roundId,
                              study: studyInfo.study,
                              onRemove: () => onRefresh(),)),),
                  ),
                  Design.padding4,

                  // Scheduled Tag
                  Visibility(
                    visible: TimeUtility.isScheduled(studyInfo.round.studyTime),
                    child: RectangleTag(
                      width: 40,
                      height: 26,
                      text: Text(
                        context.local.reserved,
                        style: TextStyles.caption1.copyWith(
                          height: 1.1,
                          color: context.extraColors.grey000,),),
                      color: context.extraColors.reservedTagColor!,
                      onTap: () => Util.pushRoute(context, (context) =>
                          RoundDetailRoute(
                              roundSeq: studyInfo.roundSeq,
                              roundId: studyInfo.round.roundId,
                              study: studyInfo.study,),),
                    ),),
                  const Spacer(),

                  StackedProfileListWidget(profileImages: studyInfo.profileImages),
                ],)
            ],),
        )],
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