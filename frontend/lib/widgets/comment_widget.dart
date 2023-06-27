import 'package:flutter/material.dart';
import 'package:group_study_app/models/comment.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';


class CommentWidget extends StatelessWidget {
  final Comment comment;

  const CommentWidget({
    Key? key,
    required this.comment
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          CircleButton(scale: 36,),
          Design.padding5,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(comment.writer.nickName, style: TextStyles.titleSmall),
              Design.padding5,
              Text(comment.content,),
            ],
      )]
    );
  }
}