import 'package:flutter/material.dart';
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
              CircleButton(scale: 70.0, image: image, onTap: onTap),
              Column( children: [
                Text(nickName, maxLines: 1, style: Theme.of(context).textTheme.titleLarge, ),
                Text(comment, maxLines: 1,), //< FIXME : Font Style 지정 필요
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
              IconButton(onPressed: (){}, icon: Icon(Icons.add)),
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