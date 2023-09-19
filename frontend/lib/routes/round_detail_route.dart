import 'package:flutter/material.dart';
import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/widgets/panels/panel.dart';
import 'package:group_study_app/widgets/round_info_widget.dart';
import 'package:group_study_app/widgets/title_widget.dart';

class RoundDetailRoute extends StatefulWidget {
  int roundNum = 1;
  int roundId = 1;
  final int studyId = Test.testStudy.studyId; // FIXME
  final int userId = 1;

  RoundDetailRoute({
    super.key,
    required this.roundNum,
    required this.roundId,
  });

  @override
  State<RoundDetailRoute> createState() {
    return _RoundDetailRoute();
  }
}

class _RoundDetailRoute extends State<RoundDetailRoute> {
  static const String _deleteRoundCautionMessage = "해당 회차를 삭제하시겠어요?";

  static const String _checkText = "확인";
  static const String _cancelText = "취소";

  static const String _detailHintText = "활동 상세 내용을 입력해 주세요";
  static const String _deleteRoundText = "삭제하기";


  late final _detailRecordEditingController = TextEditingController();
  late final _focusNode = FocusNode();

  Round? round;
  bool _isEdited = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          shadowColor: Colors.transparent,
          actions: [
            _roundPopupMenu(),
          ]
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: Design.edge15,
          child: FutureBuilder(
            future: Round.getDetail(widget.roundId),
            builder: (context, snapshot) {
            if (snapshot.hasData) {
              round = snapshot.data;
              _detailRecordEditingController.text = round!.detail??"";

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Design.padding15,
                  Design.padding15,


                  // Round Info
                  Panel(
                    boxShadows: Design.basicShadows,
                    child: RoundInfoWidget(
                      studyId: widget.studyId,
                      roundNum: widget.roundNum,
                      round: snapshot.data!,
                    ),
                  ),

                  // Detail Record
                  TitleWidget(title: "Detail Record", icon: AppIcons.edit,
                    onTap: () { _focusNode.requestFocus(); },),
                  _detailRecord(),

                ]
              );
            }

            else {
              return Design.loadingIndicator;
            }
          },)
        ),
      )
    );
  }

  Widget _detailRecord() {
    return TextField(
      minLines: 1, maxLines: 7,
      controller: _detailRecordEditingController,
      style: TextStyles.bodyLarge,
      cursorHeight: TextStyles.bodyLarge.fontSize,
      focusNode: _focusNode,
      decoration: const InputDecoration(
        hintText: _detailHintText,
        filled: true,
        fillColor: ColorStyles.grey,
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
      icon: const Icon(Icons.more_vert),
      splashRadius: 16,
      offset: const Offset(0, 42),

      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Text(_deleteRoundText, style: TextStyles.bodyMedium,),
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(_cancelText),),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (round != null) _deleteRound();
              },
              child: const Text(_checkText),),
          ],
        )
    ));
  }

  void _deleteRound() {
    Round.deleteRound(round!.roundId, widget.userId).then(
            (result) {
          if (result == true) Navigator.of(context).pop();
        }).catchError((e){
      Toast.showToast(msg: e.toString().substring(10));
    });
  }

  @override
  void dispose() {
    _detailRecordEditingController.dispose();
    super.dispose();
  }
}