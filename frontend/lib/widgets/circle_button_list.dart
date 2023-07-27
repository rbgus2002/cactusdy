import 'package:flutter/cupertino.dart';
import 'buttons/circle_button.dart';

class CircleButtonList extends StatelessWidget {
  final List<CircleButton> circleButtons;
  final double paddingVertical;

  const CircleButtonList({
    super.key,
    required this.circleButtons,
    this.paddingVertical = 5,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (CircleButton circleButton in circleButtons)
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, paddingVertical, 0),
              child: circleButton,
            )
        ],
      ),
    );
  }
}
