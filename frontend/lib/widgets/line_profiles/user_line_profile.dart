import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';
import 'package:group_study_app/widgets/panels/panel.dart';

@Deprecated("구버전")
class UserLineProfile extends StatelessWidget {
  final double scale;
  final Image? image;
  final onTap;

  final User user;

  const UserLineProfile({
    Key? key,
    this.scale: 50,
    this.image,
    this.onTap,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        // FIXME : user.image
        CircleButton(scale: scale, onTap: onTap, child: image,), //< FIXME : size should be calculated
        Design.padding5,
        Flexible(
          fit: FlexFit.tight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Design.padding5,
              Text(user.nickname, maxLines: 1, style: TextStyles.titleMedium,),
              Text(user.statusMessage, maxLines: 1, style: TextStyles.bodyMedium, textAlign: TextAlign.justify,),
              ],
            ),
          ),
        IconButton(onPressed: (){}, icon: AppIcons.edit, iconSize: 20), //< FIXME
      ],
    );
  }
}