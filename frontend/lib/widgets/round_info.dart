import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../themes/design.dart';
import '../themes/text_styles.dart';

class RoundInfo extends StatelessWidget {
  final int roundIdx;
  final String? place;
  final DateTime? date;

  const RoundInfo({
    Key? key,
    required this.roundIdx,
    this.place,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("$roundIdx", style: TextStyles.titleLarge),
        const Text(
          " 회차",
          style: TextStyles.bodyMedium, // TODO : 회차 bottomLeft에 align
          textAlign: TextAlign.right,
        ),
        const SizedBox(
          width: Design.padding,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(place ?? "", maxLines: 1, style: TextStyles.bodySmall),
            Text(
              DateFormat('yyyy-MM-dd').format(date!),
              maxLines: 1,
              style: TextStyles.bodySmall,
            ),
          ],
        ),
        const SizedBox(
          width: Design.padding,
        ),
        const Text(
          "TAG",
          textAlign: TextAlign.right
        ),
      ],
    );
  }
}
