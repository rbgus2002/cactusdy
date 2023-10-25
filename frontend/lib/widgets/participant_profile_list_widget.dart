import 'package:flutter/material.dart';
import 'package:group_study_app/models/participant_summary.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';
import 'package:group_study_app/widgets/circle_button_list.dart';
import 'package:group_study_app/widgets/dialogs/user_profile_dialog.dart';

class ParticipantProfileListWidget extends StatelessWidget {
  final int studyId;
  final double scale;
  final double padding;

  const ParticipantProfileListWidget({
    Key? key,
    required this.studyId,
    this.scale = 42.0,
    this.padding = 5.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ParticipantSummary.getParticipantsProfileImageList(studyId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CircleButton> userImages = snapshot.data!.map((userImage) =>
                CircleButton(url: userImage.picture,
                    onTap: () =>
                        UserProfileDialog.showProfileDialog(context, userImage.userId),
                    scale: scale),).toList();

            return CircleButtonList(
              circleButtons: userImages, paddingVertical: padding,);
          }
          else {
            return SizedBox(); //< FIXME
          }
        }
    );
  }
}