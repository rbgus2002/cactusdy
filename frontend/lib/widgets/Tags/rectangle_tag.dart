
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/widgets/tags/tag_widget.dart';

class RectangleTag extends TagWidget {
  const RectangleTag({
    super.key,
    required super.text,
    required super.color,
    required super.onTap,

    required super.width,
    required super.height,
  }) : super(
      radius: Design.radiusValueSmall,);
}