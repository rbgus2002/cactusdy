
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/text_styles.dart';

class FontTestRoute extends StatelessWidget {
  FontTestRoute({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('프리텐다드', style: TextStyles.head1),
            Text('프리텐다드', style: TextStyles.head2),
            Text('프리텐다드', style: TextStyles.head3),
            Text('프리텐다드', style: TextStyles.head4),
            Text('프리텐다드', style: TextStyles.head5),
            Text('프리텐다드', style: TextStyles.head6),

            Text('프리텐다드', style: TextStyles.body1),
            Text('프리텐다드', style: TextStyles.body2),
            Text('프리텐다드', style: TextStyles.body3),
            Text('프리텐다드', style: TextStyles.body4),

            Text('프리텐다드', style: TextStyles.caption1),
            Text('프리텐다드', style: TextStyles.caption2),
          ],
        ),
      )
    );
  }
}