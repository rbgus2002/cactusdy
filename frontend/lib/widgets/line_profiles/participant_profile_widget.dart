
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupstudy/models/status_tag.dart';
import 'package:groupstudy/models/user.dart';
import 'package:groupstudy/routes/profiles/profile_route.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:groupstudy/widgets/buttons/squircle_widget.dart';
import 'package:groupstudy/widgets/participant_info_widget.dart';
import 'package:groupstudy/widgets/tags/status_tag_widget.dart';

/// Participant Profile for Round Detail Route
class ParticipantProfileWidget extends StatefulWidget {
  final User user;
  final int hostId;
  final int studyId;
  final int roundParticipantId;
  final bool scheduled;
  final StatusTag status;
  final ProgressText progressTextWidget;

  const ParticipantProfileWidget({
    super.key,
    required this.user,
    required this.hostId,
    required this.studyId,
    required this.roundParticipantId,
    required this.status,
    required this.scheduled,
    required this.progressTextWidget,
  });

  @override
  State<StatefulWidget> createState() => _ParticipantProfileWidgetState();
}

class _ParticipantProfileWidgetState extends State<ParticipantProfileWidget> {
  static const double _imageSize = 48;

  late StatusTag _status;

  @override
  void initState() {
    super.initState();
    _status = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Participant Profile Image (Left Part)
        InkWell(
          onTap: () => Util.pushRouteWithSlideUp(
              context, (context, animation, secondaryAnimation) =>
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
              widget.progressTextWidget,
            ],),
        ),

        StatusTagWidget(
          width: 48,
          height: 30,
          context: context,
          status: _status,
          reserved: widget.scheduled,
          onTap: (_isEditable())?
            _showStatusPicker
            : null,
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
    if (_status != newStatus) {
      try {
        await StatusTag.updateStatus(widget.roundParticipantId, newStatus).then((value) =>
            setState(() => _status = newStatus),);
      } on Exception catch(e) {
        if (context.mounted) {
          Toast.showToast(
              context: context,
              message: Util.getExceptionMessage(e));
        }
      }
    }
  }

  bool _isEditable() {
    return (Util.isOwner(widget.user.userId) ||
        (Util.isOwner(widget.hostId)));
  }
}