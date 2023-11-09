import 'package:flutter/material.dart';
import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/themes/old_app_icons.dart';
import 'package:group_study_app/themes/old_color_styles.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/themes/old_text_styles.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/widgets/panels/old_panel.dart';
import 'package:group_study_app/widgets/participant_info_list_widget.dart';
import 'package:group_study_app/widgets/round_info_widget.dart';
import 'package:group_study_app/widgets/title_widget.dart';

class RoundDetailRoute extends StatefulWidget {
  final int roundSeq;
  final int roundId;
  final int studyId;

  const RoundDetailRoute({
    Key? key,
    required this.roundSeq,
    required this.roundId,
    required this.studyId,
  }) : super(key: key);

  @override
  State<RoundDetailRoute> createState() => _RoundDetailRouteState();
}

class _RoundDetailRouteState extends State<RoundDetailRoute> {
  static const String _deleteRoundCautionMessage = "해당 회차를 삭제하시겠어요?";

  static const String _checkText = "확인";
  static const String _cancelText = "취소";

  static const String _detailHintText = "상세 활동 내용을 입력해 주세요!";
  static const String _deleteRoundText = "삭제하기";

  final _detailRecordEditingController = TextEditingController();
  final _focusNode = FocusNode();

  Round? round;
  bool _isEdited = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _roundPopupMenu(),
        ]
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(OldDesign.padding),
          child: Column(
            children: [
              FutureBuilder(
                future: getRoundDetail(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    round = snapshot.data;
                    _detailRecordEditingController.text = round!.detail ?? "";

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Round Info
                        OldPanel(
                          boxShadows: OldDesign.basicShadows,
                          child: RoundInfoWidget(
                            roundSeq: widget.roundSeq,
                            round: snapshot.data!,
                            studyId: widget.studyId,
                          ),
                        ),
                        OldDesign.padding15,

                        // Detail Record
                        TitleWidget(
                          title: "Detail Record", icon: OldAppIcons.edit,
                          onTap: () => _focusNode.requestFocus()
                        ),
                        _detailRecord(),
                      ]
                    );
                  }

                  return OldDesign.loadingIndicator;
                },
              ),
              OldDesign.padding15,

              ParticipantInfoListWidget(roundId: widget.roundId),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _detailRecordEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<Round> getRoundDetail() async {
    if (widget.roundId == Round.nonAllocatedRoundId) {
      round = Round(roundId: Round.nonAllocatedRoundId);
      await Round.createRound(round!, widget.studyId);
      return round!;
    }

    return Round.getDetail(widget.roundId);
  }

  Widget _detailRecord() {
    return TextField(
      minLines: 3, maxLines: 7,
      controller: _detailRecordEditingController,
      style: OldTextStyles.bodyLarge,
      cursorHeight: OldTextStyles.bodyLarge.fontSize,
      focusNode: _focusNode,
      decoration: const InputDecoration(
        hintText: _detailHintText,
        filled: true,
        fillColor: OldColorStyles.grey,
        border: OutlineInputBorder(borderSide: BorderSide.none),
      ),
      onChanged: (value) { _isEdited = true; },
      onTapOutside: (event) {
        if (_isEdited) {
          Round.updateDetail(widget.roundId, _detailRecordEditingController.text);
          _isEdited = false;
        }

        _focusNode.unfocus();
      },
      maxLength: Round.detailMaxLength,
    );
  }

  Widget _roundPopupMenu() {
    return PopupMenuButton(
      icon: OldAppIcons.moreVert,
      splashRadius: 16,
      offset: const Offset(0, 42),

      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Text(_deleteRoundText, style: OldTextStyles.bodyMedium,),
          onTap: () => _showDeleteRoundDialog(context),
        ),
      ],
    );
  }

  void _showDeleteRoundDialog(BuildContext context) {
    Future.delayed(Duration.zero, ()=> showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text(_deleteRoundCautionMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(_cancelText),),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (round != null) _deleteRound(context);
              },
              child: const Text(_checkText),),
          ],
        )
    ));
  }

  void _deleteRound(BuildContext context) {
    Round.deleteRound(round!.roundId).then((result) {
          if (result == true) Navigator.of(context).pop();
        }).catchError((e) {
      Toast.showToast(context: context, message: e.toString().substring(10));
    });
  }
}