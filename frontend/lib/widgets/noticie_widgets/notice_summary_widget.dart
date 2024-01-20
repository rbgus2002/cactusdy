import 'package:flutter/material.dart';
import 'package:groupstudy/models/notice.dart';
import 'package:groupstudy/routes/notices/notice_detail_route.dart';
import 'package:groupstudy/themes/color_styles.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/time_utility.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/tags/notice_reaction_tag.dart';

class NoticeSummaryWidget extends StatefulWidget {
  final NoticeSummary noticeSummary;
  final int studyId;
  final VoidCallback onDelete;

  const NoticeSummaryWidget({
    super.key,
    required this.noticeSummary,
    required this.studyId,
    required this.onDelete,
  });

  @override
  State<NoticeSummaryWidget> createState() => _NoticeSummaryWidgetState();
}

class _NoticeSummaryWidgetState extends State<NoticeSummaryWidget> {

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.extraColors.grey200!),),),
      child: InkWell(
        child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Design.padding24,
              // Title and Pin icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title
                  Flexible(child:
                    Text(
                      widget.noticeSummary.notice.title,
                      style: TextStyles.head4.copyWith(color: context.extraColors.grey900),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,),),

                  // Pin Icon
                  IconButton(
                    icon: const Icon(CustomIcons.pin),
                    iconSize: 24,
                    color: (widget.noticeSummary.pinYn) ?
                        ColorStyles.mainColor :
                        context.extraColors.grey300,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: _switchPin,)
                ],),
              Design.padding12,

              // Notice Body Summary
              Text(
                widget.noticeSummary.notice.contents,
                style: TextStyles.body1.copyWith(color: context.extraColors.grey600),
                textAlign: TextAlign.justify,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,),
              Design.padding16,

              // Writing Date and Writer, Reaction Tag, Comment Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Writing Date & Writer
                  Text(
                      '${TimeUtility.getElapsedTime(context, widget.noticeSummary.notice.createDate)}'
                      ' • ${widget.noticeSummary.notice.writerNickname}',
                      style: TextStyles.body3.copyWith(color: context.extraColors.grey500),),

                  // Reaction Tag and Comment count
                  Row(
                    children: [
                      // Reaction Tag
                      NoticeReactionTag(
                          notice: widget.noticeSummary.notice,
                          enabled: false),
                      Design.padding8,

                      // Comment Count
                      Row(
                        children: [
                          Icon(
                            CustomIcons.comment,
                            color: context.extraColors.grey500,
                            size: 20,),
                          Design.padding(2),

                          Text(
                            '${widget.noticeSummary.commentCount}',
                            style: TextStyles.body2.copyWith(color: context.extraColors.grey600!),),
                        ],),
                    ],),
                ]
              ),
              Design.padding20,
            ],
          ),
        onTap: () {
            Util.pushRoute(context, (context) =>
                NoticeDetailRoute(
                  noticeSummary: widget.noticeSummary,
                  studyId: widget.studyId,
                  onDelete: widget.onDelete,
                ),).then((value) => setState((){ }));
        },
      ),
    );
  }

  void _switchPin() async {
    // Fast Unsafe State Update
    setState(() { widget.noticeSummary.pinYn = !widget.noticeSummary.pinYn; } );

    // Call API and Verify State
    NoticeSummary.switchNoticePin(widget.noticeSummary.notice.noticeId).then((pinYn) =>
        setState(() { widget.noticeSummary.pinYn = pinYn; })
    );
  }

  /*
  @Deprecated('deprecated for #26')
  void _switchCheck() async {
    // Fast Unsafe State Update
    setState(() {
      widget.noticeSummary.notice.read = !widget.noticeSummary.notice.read;
      (widget.noticeSummary.notice.read)? ++widget.noticeSummary.notice.checkNoticeCount: --widget.noticeSummary.notice.checkNoticeCount;
    });

    // Call API and Verify State
    Notice.switchCheckNotice(widget.noticeSummary.notice.noticeId).then((value) {
      if (value != widget.noticeSummary.notice.read) {
        setState(() {
          (widget.noticeSummary.notice.read)? --widget.noticeSummary.notice.checkNoticeCount: ++widget.noticeSummary.notice.checkNoticeCount;
          widget.noticeSummary.notice.read = value;
        });
      }
    });
  }
   */
}