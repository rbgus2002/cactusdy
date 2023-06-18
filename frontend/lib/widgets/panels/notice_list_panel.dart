import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';

class NoticeListPanel extends StatelessWidget {
  NoticeListPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ColorStyles.lightGrey,
      padding: Design.edge15,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("[공지] 내일 늦게 오는 사람 커피 사기;;", style: TextStyles.bodyLarge),
          Design.padding5,
          Text("[공지] 이번주 금요일은 종강 기념으로 쉽니다~", style: TextStyles.bodyLarge),
          Design.padding5,
          Text("[공지] 저 결혼합니다..~", style: TextStyles.bodyLarge),
          Design.padding5,
        ],
      ),
    );
  }
}