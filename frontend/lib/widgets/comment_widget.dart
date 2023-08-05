import 'package:flutter/material.dart';
import 'package:group_study_app/models/comment.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';

class CommentWidget extends StatelessWidget {
  static const String _deleteNoticeCautionMessage = "해당 댓글을 삭제하시겠어요?";
  static const String _deleteNoticeFailMessage = "댓글 삭제에 실패했습니다";

  static const String _checkMessage = "확인";
  static const String _cancelMessage = "취소";

  static const double _replyLeftPadding = 18;

  final Comment comment;
  final Function(int) onTap;
  final bool isReply;
  final int index;
  bool isSelected;

  CommentWidget({
    Key? key,
    required this.comment,
    required this.index,
    required this.onTap,
    this.isReply = false,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB((isReply)?_replyLeftPadding:0, 0, 0, 0),
      child: Column (
        children: [
          Container(
            padding: Design.edge5,
            decoration: BoxDecoration(
              color: (isSelected)?ColorStyles.grey:null,
              borderRadius: BorderRadius.circular(Design.borderRadius),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const CircleButton(scale: 36,), //<< FIXME
                Design.padding5,
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text(comment.nickname, style: TextStyles.titleSmall)),
                          if (!comment.deleteYn)
                            SizedBox(
                              width: 18,
                              height: 18,
                              child :PopupMenuButton(
                                icon: const Icon(Icons.more_vert, size: 18,),
                                splashRadius: 12,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                offset: const Offset(0, 18),

                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Text("삭제하기", style: TextStyles.bodyMedium,),
                                    onTap: () => _showDeleteCommentDialog(context),
                                  ),
                                ],
                              )
                            ),
                        ]
                      ),
                      Design.padding5,

                      SelectableText(comment.contents, textAlign: TextAlign.justify,),
                      Design.padding5,

                      if (!comment.deleteYn)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children : [
                              Text(TimeUtility.timeToString(comment.createDate), style: TextStyles.bodyMedium,),
                              const Text(" | "),
                              InkWell(
                                borderRadius: BorderRadius.circular(3),
                                onTap: (){onTap(index);},
                                child: const Text("답글 달기", style: TextStyles.bodyMedium),
                              ),
                            ]
                          ),
                    ],)
                ),
              ]
            ),
          ),

        if (comment.replies.isNotEmpty)
          for (var reply in comment.replies)
            CommentWidget(comment: reply, isReply: true, index: index, onTap: onTap,),
        ]
      ),
    );
  }

  void _showDeleteCommentDialog(BuildContext context) {
    Future.delayed(Duration.zero, ()=> showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text(_deleteNoticeCautionMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(_cancelMessage),),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteComment();
              },
              child: const Text(_checkMessage),),
          ],
        )
    ));
  }

  void _deleteComment() {
    Comment.deleteComment(comment.commentId).then((result) {
        if (result == false) {
          Toast.showToast(msg: _deleteNoticeFailMessage);
          onTap(Comment.commentWithNoParent);
        }
      },
    );
  }
}