import 'dart:math';

import 'package:flutter/material.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/widgets/dialogs/color_picker_dialog.dart';

class GenerateStudyRoute extends StatefulWidget {
  const GenerateStudyRoute({ Key? key }) : super(key: key);

  @override
  State<GenerateStudyRoute> createState() {
    return _GenerateStudyRoute();
  }
}

class _GenerateStudyRoute extends State<GenerateStudyRoute> {
  final _formKey = GlobalKey<FormState>();

  static const String _studyNameHintText = "스터디 이름을 입력해 주세요";
  static const String _studyDetailHintText = "상세 설명을 입력해 주세요";

  bool isAuthorized = true;
  Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = (isAuthorized) ?
    ColorStyles.lightGrey : ColorStyles.grey;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,),
      body: Container(
        padding: Design.edgePadding,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Design.padding10,
                      if (!isAuthorized)
                        Container(
                          padding: Design.edgePadding,
                          margin: Design.bottom15,
                          color: ColorStyles.grey,
                          child: const Text(
                            "스터디 방장만이 '스터디 이름', '상세 설명', '스터디 프로필 이미지'를 변경할 수 있어요.",
                            style: TextStyles.bodyMedium,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      Design.padding5,

                      const Text("STUDY NAME", style: TextStyles.titleSmall),
                      Design.padding5,
                      TextFormField(
                        enabled: isAuthorized,
                        maxLength: Study.studyNameMaxLength,
                        validator: (text) =>
                        ((text!.isEmpty) ? _studyNameHintText : null),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: backgroundColor,
                          hintText: _studyNameHintText,
                        ),
                      ),
                      Design.padding15,

                      const Text("DETAIL", style: TextStyles.titleSmall),
                      Design.padding5,
                      TextFormField(
                        enabled: isAuthorized,

                        maxLength: Study.studyDetailMaxLength,
                        validator: (text) =>
                        ((text!.isEmpty) ? _studyDetailHintText : null),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: backgroundColor,
                          hintText: _studyDetailHintText,
                        ),
                      ),
                      Design.padding15,

                      const Text("IMAGE", style: TextStyles.titleSmall),
                      Design.padding5,
                      TextFormField(
                        enabled: isAuthorized,
                        maxLength: Study.studyNameMaxLength,
                        validator: (text) =>
                        ((text!.isEmpty) ? _studyNameHintText : null),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: backgroundColor,
                          hintText: _studyDetailHintText,
                        ),
                      ),
                      Design.padding15,

                      const Text("STUDY COLOR", style: TextStyles.titleSmall),
                      Text("스터디 색상은 개인별로 설정할 수 있어요",
                        style: TextStyles.bodySmall,),
                      Design.padding5,
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,

                          ),
                          onPressed: () =>
                              ColorPickerDialog.showColorPickerDialog(
                                  context: context,
                                  color: color,
                                  onColorChange: changeColor),
                          child: null),
                    ],
                  ),
                  Design.padding15,

                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate())
                          print("에바!");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Text("완료"),
                        width: double.infinity,
                      )
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }

  void changeColor(Color newColor) {
    setState(() { color = newColor; });
  }
}