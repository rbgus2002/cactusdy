import 'package:flutter/material.dart';
import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/panels/panel.dart';
import 'package:group_study_app/widgets/panels/round_info_panel.dart';
import 'package:group_study_app/widgets/round_info_widget.dart';
import 'package:group_study_app/widgets/title_widget.dart';

class RoundDetailRoute extends StatefulWidget {
  String content = "오늘도 규현이와 예지누나가 숙제를 안해왔다. 뒤졌다 진짜." +
       "이제 앞으로는 안해온 사람이 밥사기로 결정하였다. 근데 벌써부터 다음주에 얻어먹을 것 같은 기분이다. " +
       "다음주부터는 시험기간이니 다다음주에 다음 스터디를 하기로 결정하였다.";

  int index = 1;
  int roundId = 1;
  @override
  State<RoundDetailRoute> createState() {
    return _RoundDetailRoute();
  }
}

class _RoundDetailRoute extends State<RoundDetailRoute> {
  late final _detailRecordEditingController = TextEditingController();
  late final _focusNode = FocusNode();

  late Future<Round> round;
  bool _isEdited = false;

  @override
  void initState() {
    super.initState();
    round = Round.getDetail(widget.roundId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,),
      body: SingleChildScrollView(
        child: Container(
          padding: Design.edge15,
          child: FutureBuilder(
            future: round,
            builder: (context, snapshot) {
            if (snapshot.hasData) {
              _detailRecordEditingController.text = snapshot.data!.detail??"";

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Design.padding15,
                  Design.padding15,

                  // Round Info
                  Panel(
                    boxShadows: Design.basicShadows,
                    child: RoundInfoWidget(
                      index: widget.index,
                      round: snapshot.data!,
                    ),
                  ),

                  // Detail Record
                  TitleWidget(title: "Detail Record", icon: AppIcons.edit, onTap: () {},),
                  _detailRecord(),

                  //TitleWidget(title: "Detail Record", icon: null),
                ]
              );
            }

            else {
              return SizedBox();
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
        filled: true,
        fillColor: ColorStyles.grey,
        border: OutlineInputBorder(borderSide: BorderSide.none),
      ),
      onChanged: (value) { _isEdited = true; },
      onTapOutside: (event) {
        if (_isEdited) {
          Test.onTabTest();
          Round.updateDetail(widget.roundId, _detailRecordEditingController.text);
          _isEdited = false;
        }

        _focusNode.unfocus();
      },
      maxLength: Round.detailMaxLength,
    );
  }

  @override
  void dispose() {
    _detailRecordEditingController.dispose();
    super.dispose();
  }
}