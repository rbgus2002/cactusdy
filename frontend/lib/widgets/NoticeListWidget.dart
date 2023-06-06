import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';

class NoticeListWidget extends StatelessWidget {
  NoticeListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ColorStyles.grey
      ,height: 100,
      child: Text("Noice")
    );
  }
}