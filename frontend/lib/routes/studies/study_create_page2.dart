
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/widgets/buttons/primary_button.dart';
import 'package:group_study_app/widgets/dialogs/bottom_sheets.dart';
import 'package:group_study_app/widgets/image_picker_widget.dart';
import 'package:image_picker/image_picker.dart';

class StudyCreatePage2 extends StatefulWidget {
  final Function(Color, XFile?) getNext;

  const StudyCreatePage2({
    Key? key,
    required this.getNext,
  }) : super(key: key);

  @override
  State<StudyCreatePage2> createState() => _StudyCreatePage2State();
}

class _StudyCreatePage2State extends State<StudyCreatePage2> {
  XFile? _profileImage;
  Color _studyColor = ColorStyles.mainColor;

  @override
  void initState() {
    super.initState();

    int rand = Random().nextInt(ColorStyles.studyColors.length);
    _studyColor = ColorStyles.studyColors[rand];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Design.padding(40),

        // Image Picker
        Container(
          alignment: Alignment.center,
          child: ImagePickerWidget(
            backgroundColor: _studyColor.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: Design.borderRadius,
              side: BorderSide(color: context.extraColors.grey200!, width: 2),),
            onPicked: (pickedImage) => _profileImage = pickedImage,),),
        Design.padding28,

        _studyColorWidget(),
        Design.padding(400),

        PrimaryButton(
          text: context.local.next,
          onPressed: () => _getNext(),),
      ],
    );
  }

  Widget _studyColorWidget() {
    return Row(
      children: [
        // Title and Hint
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(context.local.studyColor,
                style: TextStyles.head5.copyWith(color: context.extraColors.grey900),),
              Design.padding4,

              // Hint
              Text(context.local.studyColorHint,
                style: TextStyles.body2.copyWith(color: context.extraColors.grey600),),
            ],),),

        // Color Picker Button
        InkWell(
          onTap: () => BottomSheets.colorPickerBottomSheet(
            context: context,
            onChose: (newColor) => setState(() => _studyColor = newColor),),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: _studyColor,),
              Design.padding12,

              Icon(
                CustomIcons.drop_down,
                size: 12,
                color: context.extraColors.grey300,),
            ],),),
      ],
    );
  }

  void _getNext() {
    widget.getNext(_studyColor, _profileImage);
  }
}
