import 'package:flutter/material.dart';
import 'package:group_study_app/models/comment.dart';
import 'package:group_study_app/routes/profile_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/old_text_styles.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/squircle_widget.dart';

class CommentWidget extends StatelessWidget {
  static const String _deleteNoticeCautionMessage = "해당 댓글을 삭제하시겠어요?"; //< FIXME
  static const String _deleteNoticeFailMessage = "댓글 삭제에 실패했습니다";

  static const String _confirmText = "확인";
  static const String _cancelText = "취소";

  static const String _showProfileText = "프로필 보기";
  static const String _deleteCommentText = "삭제하기";

  static const double _replyLeftPadding = 50;

  static const double _imageSize = 36;
  static const double _replayImageSize = 24;

  final Comment comment;
  final int studyId;
  final Function(int) setReplyTo;
  final Function onDelete;
  final bool isReply;
  final int index;
  bool isSelected;

  CommentWidget({
    Key? key,
    required this.comment,
    required this.studyId,
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: (isSelected)?ColorStyles.mainColor.withOpacity(0.05):null,
              borderRadius: Design.borderRadius),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SquircleImageWidget(
                    scale: (!isReply)? _imageSize : _replayImageSize,
                    url: comment.picture),
                Design.padding12,

                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              comment.nickname,
                              style: TextStyles.head6.copyWith(
                                  color: context.extraColors.grey800),),),

                          if (!comment.deleteYn)
                            _commentPopupMenu(context),
                        ]),
                      Design.padding4,

                      Text(
                        TimeUtility.getElapsedTime(comment.createDate),
                        style: TextStyles.body4.copyWith(color: context.extraColors.grey500),),
                      Design.padding8,

                      SelectableText(
                        comment.contents,
                        style: TextStyles.body1.copyWith(color: context.extraColors.grey800),
                        textAlign: TextAlign.justify,),
                      Design.padding8,

                      Visibility(
                        visible: _isReplyAble(),
                        child: InkWell(
                          borderRadius: Design.borderRadiusSmall,
                          onTap: () => setReplyTo(index),
                          child: Text(
                              context.local.writeReply,
                              style: TextStyles.caption1.copyWith(
                                  color: context.extraColors.grey500),),),),
                    ],)
                ),
              ]
            ),
          ),

        if (comment.replies.isNotEmpty)
          for (var reply in comment.replies)
            CommentWidget(
              comment: reply,
              studyId: studyId,
              isReply: true,
              index: index,
              setReplyTo: setReplyTo,
              onDelete: onDelete,),
        ]
      ),
    );
  }

  Widget _commentPopupMenu(BuildContext context) {
    return SizedBox(
        width: 18,
        height: 18,
        child: PopupMenuButton(
          icon: Icon(Icons.more_vert, color: context.extraColors.grey500,),
          iconSize: 18,
          splashRadius: 12,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          offset: const Offset(0, 18),

          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text(_showProfileText, style: OldTextStyles.bodyMedium,),
              onTap: () {
                Future.delayed(Duration.zero, ()=>
                  Util.pushRouteWithSlideDown(context, (context, animation, secondaryAnimation) =>
                      ProfileRoute(userId: comment.userId, studyId: studyId)));
              }),

            if (comment.userId == Auth.signInfo!.userId)
            PopupMenuItem(
              child: const Text(_deleteCommentText, style: OldTextStyles.bodyMedium,),
              onTap: () => _showDeleteCommentDialog(context),),
        ],),
    );
  }

  void _showDeleteCommentDialog(BuildContext context) {
    Future.delayed(Duration.zero, ()=> showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text(_deleteNoticeCautionMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Util.popRoute(context),
              child: const Text(_cancelText),),
            TextButton(
              onPressed: () {
                Util.popRoute(context);
                onDelete(comment.commentId);
              },
              child: const Text(_confirmText),),
          ],
        )
    ));
  }

  bool _isReplyAble() {
    return !(comment.deleteYn || isReply);
  }
}