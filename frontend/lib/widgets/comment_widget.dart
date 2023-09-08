import 'package:flutter/material.dart';
import 'package:group_study_app/models/comment.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';
import 'package:group_study_app/widgets/dialogs/user_profile_dialog.dart';

class CommentWidget extends StatelessWidget {
  static const String _deleteNoticeCautionMessage = "해당 댓글을 삭제하시겠어요?";
  static const String _deleteNoticeFailMessage = "댓글 삭제에 실패했습니다";

  static const String _confirmText = "확인";
  static const String _cancelText = "취소";

  static const String _showProfileText = "프로필 보기";
  static const String _deleteCommentText = "삭제하기";

  static const String _writeReplyText = "답글 달기";

  static const double _replyLeftPadding = 18;

  //< FIXME
  final int userId = Test.testUser.userId;

  final Comment comment;
  final Function(int) setReplyTo;
  final Function onDelete;
  final bool isReply;
  final int index;
  bool isSelected;

  CommentWidget({
    Key? key,
    required this.comment,
    required this.index,
    required this.setReplyTo,
    required this.onDelete,
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
                              child : _commentPopupMenu(),
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
                                onTap: (){setReplyTo(index);},
                                child: const Text(_writeReplyText, style: TextStyles.bodyMedium),
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
            CommentWidget(comment: reply, isReply: true, index: index, setReplyTo: setReplyTo, onDelete: onDelete,),
        ]
      ),
    );
  }

  Widget _commentPopupMenu() {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert, size: 18,),
      splashRadius: 12,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      offset: const Offset(0, 18),

      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Text(_showProfileText, style: TextStyles.bodyMedium,),
          onTap: () {
            Future.delayed(Duration.zero, ()=>
              UserProfileDialog.showProfileDialog(context, comment.userId)); }
        ),

        if (userId == comment.userId)
        PopupMenuItem(
          child: const Text(_deleteCommentText, style: TextStyles.bodyMedium,),
          onTap: () => _showDeleteCommentDialog(context),
        )
      ],
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
              child: const Text(_cancelText),),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onDelete(comment.commentId);
              },
              child: const Text(_confirmText),),
          ],
        )
    ));
  }
}