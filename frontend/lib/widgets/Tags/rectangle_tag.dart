
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/widgets/tags/tag_widget.dart';

class RectangleTag extends TagWidget {
  const RectangleTag({
    Key? key,
    required super.text,
    required super.color,
    required super.onTap,

    required super.width,
    required super.height,
  }) : super(
      key: key,
      radius: Design.radiusValueSmall,);
}