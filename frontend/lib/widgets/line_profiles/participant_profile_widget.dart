
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_study_app/models/status_tag.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/routes/profiles/profile_route.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/squircle_widget.dart';
import 'package:group_study_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:group_study_app/widgets/tags/status_tag_widget.dart';

/// Participant Profile for Round Detail Route
class ParticipantProfileWidget extends StatefulWidget {
  final User user;
  final int studyId;
  final int roundParticipantId;
  final double taskProgress;
  final bool reserved;
  StatusTag status;

  ParticipantProfileWidget({
    Key? key,
    required this.user,
    required this.studyId,
    required this.roundParticipantId,
    required this.taskProgress,
    required this.status,
    required this.reserved,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ParticipantProfileWidgetState();
}

class _ParticipantProfileWidgetState extends State<ParticipantProfileWidget> {
  static const double _imageSize = 48;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Participant Profile Image (Left Part)
        InkWell(
          onTap: () => Util.pushRouteWithSlideUp(context, (context, animation, secondaryAnimation) =>
            ProfileRoute(
                userId: widget.user.userId,
                studyId: widget.studyId),),
          child: SquircleImageWidget(
              scale: _imageSize,
              url: widget.user.profileImage),),
        Design.padding12,

        // User nickname & status message
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nickname
              Text(
                  widget.user.nickname,
                  style: TextStyles.head4.copyWith(color: context.extraColors.grey900)),
              Design.padding4,

              // Task Progress (%)
              Text(
                  '${(widget.taskProgress * 100).toStringAsFixed(1)}%',
                  style: TextStyles.head5.copyWith(color: ColorStyles.mainColor)),
            ],),
        ),

        StatusTagWidget(
          width: 48,
          height: 30,
          context: context,
          status: widget.status,
          reserved: widget.reserved,
          onTap: _showStatusPicker,
        ),
      ],
    );
  }

  void _showStatusPicker() {
    HapticFeedback.lightImpact();
    BottomSheets.statusTagPickerBottomSheet(
        context: context,
        onPicked: _updateStatus);
  }

  void _updateStatus(StatusTag newStatus) async {
    HapticFeedback.lightImpact();
    if (widget.status != newStatus) {
      try {
        await StatusTag.updateStatus(widget.roundParticipantId, newStatus).then((value) =>
            setState((){ }),);
      } on Exception catch(e) {
        if (context.mounted) {
          Toast.showToast(
              context: context,
              message: Util.getExceptionMessage(e));
        }
      }
      widget.status = newStatus;
    }
  }
}