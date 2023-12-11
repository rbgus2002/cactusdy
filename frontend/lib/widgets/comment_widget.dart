import 'package:flutter/material.dart';
import 'package:group_study_app/models/comment.dart';
import 'package:group_study_app/routes/profiles/profile_route.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/squircle_widget.dart';
import 'package:group_study_app/widgets/dialogs/two_button_dialog.dart';

class CommentWidget extends StatelessWidget {
  static const double _replyLeftPadding = 50;

  static const double _imageSize = 36;
  static const double _replayImageSize = 24;

  final Comment comment;
  final int studyId;
  final Function(int) setReplyTo;
  final Function onDelete;
  final bool isReply;
  final int index;
  final bool isSelected;

  const CommentWidget({
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
      padding: EdgeInsets.only(left: (isReply)?_replyLeftPadding:0),
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
                        TimeUtility.getElapsedTime(context, comment.createDate),
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
          icon: Icon(
            Icons.more_vert,
            color: context.extraColors.grey500,
            size: 18,),
          splashRadius: 12,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 128),

          itemBuilder: (context) => [
            // show writer profile
            PopupMenuItem(
                height: 44,
                child: Text(context.local.viewProfile, style: TextStyles.body1),
                onTap: () => Util.pushRouteWithSlideUp(context, (context, animation, secondaryAnimation) =>
                      ProfileRoute(userId: comment.userId, studyId: studyId))),

            // delete comment
            if (Util.isOwner(comment.userId))
            PopupMenuItem(
                height: 44,
                child: Text(context.local.delete, style: TextStyles.body1),
                onTap: () => TwoButtonDialog.showProfileDialog(
                  context: context,
                  text: context.local.confirmDeleteComment,

                  buttonText1: context.local.no,
                  onPressed1: Util.doNothing,

                  buttonText2: context.local.delete,
                  onPressed2: () => onDelete(comment.commentId),),),
        ],),
    );
  }

  bool _isReplyAble() {
    return !(comment.deleteYn || isReply);
  }
}