import 'package:flutter/material.dart';
import 'package:group_study_app/models/comment.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';

class CommentWidget extends StatefulWidget {
  final Comment comment;
  final bool isReply;
  bool isSelected;

  CommentWidget({
    Key? key,
    required this.comment,
    this.isReply = false,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidget();
}

class _CommentWidget extends State<CommentWidget> {
  static const double _replyLeftPadding = 18;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB((widget.isReply)?_replyLeftPadding:0, 0, 0, 0),
      child: Column (
        children: [
          Container(
            decoration: BoxDecoration(
              color: (widget.isSelected)?ColorStyles.grey:null,
              borderRadius: BorderRadius.circular(Design.borderRadius),
            ),
            padding: Design.edge5,
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              CircleButton(scale: 36,),
              Design.padding5,
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(widget.comment.nickname, style: TextStyles.titleSmall),
                    Design.padding5,

                    Text(widget.comment.contents, textAlign: TextAlign.justify,),
                    Design.padding5,

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children : [
                          Text(TimeUtility.timeToString(widget.comment.createDate), style: TextStyles.bodyMedium,),
                          const Text(" | "),
                          InkWell(
                            borderRadius: BorderRadius.circular(3),
                            child: const Text("답글 달기", style: TextStyles.bodyMedium),
                            onTap: () {
                              setState(() {
                                widget.isSelected = true;
                              });
                            },
                          ),
                        ]
                    ),
                  ],)
              ),
              Icon(Icons.more_vert, size: 18,)
            ]
          ),
        ),
        if (widget.comment.replies.isNotEmpty)
          for (var reply in widget.comment.replies)
            CommentWidget(comment: reply, isReply: true,),
        ]
      ),
    );
  }
}