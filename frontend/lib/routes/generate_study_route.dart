import 'dart:math';

import 'package:flutter/material.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/themes/old_color_styles.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/themes/old_text_styles.dart';
import 'package:group_study_app/widgets/dialogs/color_picker_dialog.dart';

class GenerateStudyRoute extends StatefulWidget {
  const GenerateStudyRoute({ 
    Key? key 
  }) : super(key: key);

  @override
  State<GenerateStudyRoute> createState() => _GenerateStudyRouteState();
}

class _GenerateStudyRouteState extends State<GenerateStudyRoute> {
  final _formKey = GlobalKey<FormState>();

  static const String _studyNameHintText = "스터디 이름을 입력해 주세요";
  static const String _studyDetailHintText = "상세 설명을 입력해 주세요";

  bool isAuthorized = true; //< FIXME : id? -> auth
  Color _color = Colors.primaries[Random().nextInt(Colors.primaries.length)]; //< FIXME : is this best?

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = (isAuthorized) ?
    OldColorStyles.lightGrey : OldColorStyles.grey;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,),
      body: Container(
        padding: OldDesign.edgePadding,
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
                      OldDesign.padding10,
                      if (!isAuthorized)
                        Container(
                          padding: OldDesign.edgePadding,
                          margin: OldDesign.bottom15,
                          color: OldColorStyles.grey,
                          child: const Text(
                            "스터디 방장만이 '스터디 이름', '상세 설명', '스터디 프로필 이미지'를 변경할 수 있어요.",
                            style: OldTextStyles.bodyMedium,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      OldDesign.padding5,

                      const Text("STUDY NAME", style: OldTextStyles.titleSmall),
                      OldDesign.padding5,
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
                      OldDesign.padding15,

                      const Text("DETAIL", style: OldTextStyles.titleSmall),
                      OldDesign.padding5,
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
                      OldDesign.padding15,

                      const Text("IMAGE", style: OldTextStyles.titleSmall),
                      OldDesign.padding5,
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
                      OldDesign.padding15,

                      const Text("STUDY COLOR", style: OldTextStyles.titleSmall),
                      Text("스터디 색상은 개인별로 설정할 수 있어요",
                        style: OldTextStyles.bodySmall,),
                      OldDesign.padding5,
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _color,

                          ),
                          onPressed: () =>
                              ColorPickerDialog.showColorPickerDialog(
                                  context: context,
                                  color: _color,
                                  onColorChange: changeColor),
                          child: null),
                    ],
                  ),
                  OldDesign.padding15,
                  OldDesign.padding15,

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
    setState(() { _color = newColor; });
  }
}