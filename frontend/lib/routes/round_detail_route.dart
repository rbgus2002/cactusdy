import 'package:flutter/material.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/widgets/panels/round_info_panel.dart';
import 'package:group_study_app/widgets/title_widget.dart';

class RoundDetailRoute extends StatefulWidget {
  String content = "오늘도 규현이와 예지누나가 숙제를 안해왔다. 뒤졌다 진짜." +
       "이제 앞으로는 안해온 사람이 밥사기로 결정하였다. 근데 벌써부터 다음주에 얻어먹을 것 같은 기분이다. " +
       "다음주부터는 시험기간이니 다다음주에 다음 스터디를 하기로 결정하였다.";

  @override
  State<RoundDetailRoute> createState() {
    return _RoundDetailRoute();
  }
}

class _RoundDetailRoute extends State<RoundDetailRoute> {
  late final detailRecordEditingController = TextEditingController(
    text: widget.content,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,),
      body: SingleChildScrollView(
        child: Container(
          padding: Design.edge15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Design.padding15,
              Design.padding15,

              // Round Info
              RoundInfoPanel(roundIdx: 1,),

              // Detail Record
              //Text("Detail Record", style: TextStyles.titleMedium),
              TitleWidget(title: "Detail Record", icon: AppIcons.edit, onTap: () {},),
              TextField(
                minLines: 3, maxLines: 7,
                controller: detailRecordEditingController,
                style: TextStyles.bodyLarge,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: ColorStyles.grey,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),


              //TitleWidget(title: "Detail Record", icon: null),
            ]
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    detailRecordEditingController.dispose();
    super.dispose();
  }
}