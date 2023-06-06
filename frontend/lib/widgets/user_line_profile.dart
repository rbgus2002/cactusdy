import 'package:flutter/material.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';
import 'package:group_study_app/widgets/panels/panel.dart';

class UserLineProfile extends StatelessWidget {
  final double scale;
  final Image? image;
  final onTap;

  final String nickName;
  final String comment;

  const UserLineProfile({
    Key? key,
    this.scale: 65,
    this.image,
    this.onTap,
    required this.nickName,
    required this.comment,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        CircleButton(scale: 60.0, onTap: onTap, child: image,), //< FIXME : size should be calculated
        Design.padding10,
        Flexible(
          fit: FlexFit.tight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(nickName, maxLines: 1, style: TextStyles.titleLarge,),
              Text(comment, maxLines: 1, style: TextStyles.bodyLarge,),
              ],
            ),
          ),
        IconButton(onPressed: (){}, icon: AppIcons.edit), //< FIXME
        ],
    );
  }
}