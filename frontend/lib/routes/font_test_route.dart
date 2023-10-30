
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/new_text_styles.dart';

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
            Text('프리텐다드', style: NewTextStyles.head1),
            Text('프리텐다드', style: NewTextStyles.head2),
            Text('프리텐다드', style: NewTextStyles.head3),
            Text('프리텐다드', style: NewTextStyles.head4),
            Text('프리텐다드', style: NewTextStyles.head5),
            Text('프리텐다드', style: NewTextStyles.head6),

            Text('프리텐다드', style: NewTextStyles.body1),
            Text('프리텐다드', style: NewTextStyles.body2),
            Text('프리텐다드', style: NewTextStyles.body3),
            Text('프리텐다드', style: NewTextStyles.body4),

            Text('프리텐다드', style: NewTextStyles.caption1),
            Text('프리텐다드', style: NewTextStyles.caption2),
          ],
        ),
      )
    );
  }
}