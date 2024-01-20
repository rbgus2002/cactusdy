
import 'package:groupstudy/widgets/tags/tag_widget.dart';

class RoundedTag extends TagWidget {
  const RoundedTag({
    super.key,
    required super.text,
    required super.color,
    super.onTap,

    required super.width,
    required super.height,
  }) : super(
        radius: height / 2);
}