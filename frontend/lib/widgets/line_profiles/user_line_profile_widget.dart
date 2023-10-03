import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';
import 'package:group_study_app/widgets/line_profiles/line_profile_widget.dart';

class UserLineProfileWidget extends StatelessWidget {
  static const double _scale = 50;

  final User user;

  const UserLineProfileWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineProfileWidget(
      circleButton: const CircleButton(
        scale: _scale,
        child: null, //< FIXME
      ),

      topWidget: Text(user.nickname, maxLines: 1, style: TextStyles.titleMedium,),
      bottomWidget: Text(user.statusMessage, maxLines: 1, style: TextStyles.bodyMedium,
        textAlign: TextAlign.justify,),

      suffixWidget: (user.userId != Auth.signInfo!.userId)? null : IconButton(
        icon: AppIcons.edit,
        splashRadius: 16,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        iconSize: 18,
        onPressed: (){},
      ),
    );
  }
}