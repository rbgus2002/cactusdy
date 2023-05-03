import 'package:flutter/material.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/widgets/circle_button.dart';

class UserLineProfile extends StatelessWidget {
  final double scale;
  final Image? image;
  final onTap;

  final String nickName;
  final String comment;

  UserLineProfile({
    Key? key,
    this.scale: 200,
    this.image,
    this.onTap,
    required this.nickName,
    required this.comment,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        child: InkWell(
          child: Row(
            children: [
              CircleButton(scale: 65.0, image: image, onTap: onTap,),
              const SizedBox(width: 10,),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nickName, maxLines: 1, style: TextStyles.titleSmall,),
                    Text(comment, maxLines: 1, style: TextStyles.bodyMedium,),
                    ],
                  ),
                ),
              IconButton(onPressed: (){}, icon: AppIcons.edit),
              ],
            ),
            onTap: () {
              if (onTap != null) {
                onTap();
              }
            },
          ),
        )
    );
  }
}