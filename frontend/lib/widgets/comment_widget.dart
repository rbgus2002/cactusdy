import 'package:flutter/material.dart';
import 'package:group_study_app/models/comment.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';


class CommentWidget extends StatelessWidget {
  final Comment comment;
  final List<Comment> replies;
  final double paddingLeft;

  const CommentWidget({
    Key? key,
    required this.comment,
    this.replies = const [],
    this.paddingLeft = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(paddingLeft, 10, 0, 0),
      child: Column (
        children: [
          Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            CircleButton(scale: 36,),
            Design.padding5,
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(comment.writer.nickName, style: TextStyles.titleSmall),
                  Design.padding5,

                  Text(comment.content, textAlign: TextAlign.justify,),
                  Design.padding5,

                  Row(
                      children : [
                        Text(TimeUtility.timeToString(comment.writingTime), style: TextStyles.bodyMedium,),
                        Text(" | 답글 달기", style: TextStyles.bodyMedium,),
                      ]
                  ),
                ],)
            ),
            Icon(Icons.more_vert, size: 18,)
          ]
        ),
        for (var reply in replies)
          CommentWidget(comment: reply, paddingLeft: 18,),
      ]
      ),
    );
  }
}