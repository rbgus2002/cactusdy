

import 'package:flutter/material.dart';
import 'package:group_study_app/routes/studies/study_create_page0.dart';
import 'package:group_study_app/routes/studies/study_create_page1.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:image_picker/image_picker.dart';

class StudyCreateRoute extends StatefulWidget {
  const StudyCreateRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<StudyCreateRoute> createState() => _StudyCreateRouteState();
}

class _StudyCreateRouteState extends State<StudyCreateRoute> {
  String _studyName = "";
  String _studyDetail = "";
  Color _studyColor = ColorStyles.mainColor;
  XFile? _profileImage;

  int _page = 0;
  int _progress = 33;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: _progressBar(33),),),
      body: SingleChildScrollView(
        padding: Design.edgePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Design.padding4,
            Text(
              context.local.setStudyInfo,
              style: TextStyles.head2.copyWith(
                color: context.extraColors.grey800,),),

            (_page == 0)?
              StudyCreatePage0(getNext: _pageRoute0To1,) :
              StudyCreatePage1(getNext: _pageRoute1To2,),

          ],),),
    );
  }

  void _pageRoute0To1(String studyName, String studyDetail) {
    if (_page == 0) {
      setState(() {
        _studyName = studyName;
        _studyDetail = studyDetail;

        _page = 1;
        _progress = 66;
      });
    }
  }

  void _pageRoute1To2(Color studyColor, XFile? profileImage) {
    if (_page == 1) {
      setState(() {
        _studyColor = studyColor;
        _profileImage = profileImage;

        _page = 2;
        _progress = 100;
      });
    }
  }

  Widget _progressBar(int percent) {
    return Row(
      children: [
        Expanded(
          flex: percent,
          child: Container(
            height: 4,
            color: ColorStyles.mainColor,),),
        Expanded(
          flex: 100 - percent,
          child: Container(
            height: 4,
            color: context.extraColors.grey100,),),
      ],
    );
  }
}

