
import 'package:flutter/material.dart';
import 'package:groupstudy/widgets/tags/tag_widget.dart';

class RoundedTag extends TagWidget {
  const RoundedTag({
    Key? key,
    required super.text,
    required super.color,
    super.onTap,

    required super.width,
    required super.height,
  }) : super(
        key: key,
        radius: height / 2);
}