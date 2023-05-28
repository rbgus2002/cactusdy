import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/widgets/circle_button.dart';

// 수정할 것 list
// user_line_profile : profile 수정 버튼 onPressed

// Tag의 일관적인 경험 제공을 위한 scale 통일 제안
// margin 추가

class TagButton extends StatelessWidget{
  static const double height = 24;

  Color color;

  final EdgeInsets? padding;
  final Widget? child;
  final Function? onTap;

  TagButton({
    Key? key,
    this.color = ColorStyles.transparent,
    this.padding,
    this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: height, minWidth: height * 2.25),
      height: height,
      padding: padding,

      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height * 0.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(height * 0.5),
        child: Center(
          widthFactor: 1,
          child: child,
        ),
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
      )
    );

  }
}

class UserStateTag extends TagButton {
  static const userStateTagPadding = EdgeInsets.fromLTRB(10, 0, 10, 0);
  String text;

  UserStateTag({
    this.text = "",
    super.key,
    super.color,
    super.onTap }) : super(
      padding: userStateTagPadding,
      child: Text(text, textWidthBasis: TextWidthBasis.parent,
        style: TextStyles.tagTextStyle, textAlign: TextAlign.center,),
  );
}

class StudyTag extends TagButton {
  static const studyTagPadding = EdgeInsets.fromLTRB(3, 3, 10, 3);
  Image? image;
  String name;

  StudyTag({
    this.image,
    this.name = "",
    super.key,
    super.color,
    super.onTap }) : super(
      padding: studyTagPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          const CircleButton(scale:20, onTap: null),
          Design.padding5,
          Text(name, style: TextStyles.tagTextStyle, textAlign: TextAlign.center),
        ],)
   );
}