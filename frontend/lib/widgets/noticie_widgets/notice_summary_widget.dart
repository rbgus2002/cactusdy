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
  late Notice _noticeRef;

  @override
  void initState() {
    super.initState();
    _noticeRef = widget.noticeSummary.notice;
  }

  @override
  void didUpdateWidget(covariant NoticeSummaryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _noticeRef = widget.noticeSummary.notice;
  }

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
                      _noticeRef.title,
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
                _noticeRef.contents,
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
                      '${TimeUtility.getElapsedTime(context, _noticeRef.createDate)}'
                      ' • ${_noticeRef.writerNickname}',
                      style: TextStyles.body3.copyWith(color: context.extraColors.grey500),),

                  // Reaction Tag and Comment count
                  Row(
                    children: [
                      // Reaction Tag
                      NoticeReactionTag(
                          notice: _noticeRef,
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
    NoticeSummary.switchNoticePin(_noticeRef.noticeId).then((pinYn) =>
        setState(() { widget.noticeSummary.pinYn = pinYn; })
    );
  }

  /*
  @Deprecated('deprecated for #26')
  void _switchCheck() async {
    // Fast Unsafe State Update
    setState(() {
      _noticeRef.read = !_noticeRef.read;
      (_noticeRef.read)? ++_noticeRef.checkNoticeCount: --_noticeRef.checkNoticeCount;
    });

    // Call API and Verify State
    Notice.switchCheckNotice(_noticeRef.noticeId).then((value) {
      if (value != _noticeRef.read) {
        setState(() {
          (_noticeRef.read)? --_noticeRef.checkNoticeCount: ++_noticeRef.checkNoticeCount;
          _noticeRef.read = value;
        });
      }
    });
  }
   */
}