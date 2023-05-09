import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../themes/design.dart';
import '../themes/text_styles.dart';

class RoundInfo extends StatelessWidget {
  final int roundIdx;
  final String? place;
  final String tag;
  final DateTime? date;

  const RoundInfo({
    Key? key,
    required this.roundIdx,
    required this.tag,
    this.place,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text("$roundIdx", style: TextStyles.titleLarge),
            const Text(
              " 회차",
              style: TextStyles.bodyMedium,
              textAlign: TextAlign.right,
            ),
          ],
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
        Design.padding15,
        Design.padding15,
        Text(tag)
      ],
    );
  }
}
