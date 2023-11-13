import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_study_app/models/participant_summary.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/widgets/buttons/squircle_widget.dart';
import 'package:group_study_app/widgets/dialogs/user_profile_dialog.dart';

class MemberProfileListWidget extends StatelessWidget {
  final int studyId;
  final double scale;
  final double margin;

  const MemberProfileListWidget({
    Key? key,
    required this.studyId,
    this.scale = 40.0,
    this.margin = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ParticipantSummary.getParticipantsProfileImageList(studyId),
        builder: (context, snapshot) =>
            (snapshot.hasData) ?
            SizedBox(
              height: scale,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length + 1,
                itemBuilder: (context, index) {
                  if (index == snapshot.data!.length) {
                    return _addButton(context);
                  }

                  return Container(
                    margin: EdgeInsets.only(right: margin),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        InkWell(
                          child: SquircleWidget(
                            scale: scale,
                            child: (snapshot.data![index].picture.isNotEmpty) ?
                              CachedNetworkImage(
                                  imageUrl: snapshot.data![index].picture,
                                  fit: BoxFit.cover) : null,),
                          onTap: () => UserProfileDialog.showProfileDialog(
                              context,
                              snapshot.data![index].userId),),
                        
                        if (index == 0)
                          _adminBadge(),
                      ],
                    ),
                  );
                },
              ),
            ) : const SizedBox(height: 40,)
    );
  }

  Widget _addButton(BuildContext context) {
    return InkWell(
      child: SquircleWidget(
        scale: scale,
        backgroundColor:Colors.transparent,
        child: Icon(
            size: 24,
            Icons.add,
            color: context.extraColors.grey400,),),
      onTap: () {});
  }

  Widget _adminBadge() {
    return Positioned(
        left: -4,
        top: 24,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: Design.basicShadows,),
          child: Image.asset(
            'assets/images/crown.png',
            height: 18,
            width: 18,),
        )
    );
  }
}