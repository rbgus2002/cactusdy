
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/widgets/buttons/outlined_primary_button.dart';
import 'package:group_study_app/widgets/buttons/primary_button.dart';
import 'package:group_study_app/widgets/buttons/secondary_button.dart';
import 'package:group_study_app/widgets/input_field.dart';

class DesignTestRoute extends StatelessWidget {
  DesignTestRoute({
    Key? key,
  }) : super(key: key);

  final _inputFieldKey = GlobalKey<InputFieldState>();

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
            Text('프리텐다드', style: TextStyles.head1.copyWith(letterSpacing: -0.64)),
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

            OldDesign.padding15,
            InputField(
              key: _inputFieldKey,
              hintText: "입력필드",
              validator: (text) {
                if (text == null || text.length < 6)
                  return "길이가 부족행";
                return null;
              },
            ),

            OldDesign.padding15,
            PrimaryButton(
                text: "버튼",
                onPressed: () {
                  _inputFieldKey.currentState!.validate();
                },
            ),

            OldDesign.padding15,
            SecondaryButton(
                text: '버튼',
                onPressed: () { Toast.showToast(context: context, message: "테스트 우해해"); }
            ),

            OldDesign.padding15,
            OutlinedPrimaryButton(
                text: '버튼',
                onPressed: Test.onTabTest),
            OldDesign.padding15,
            PrimaryButton(

              text: "버튼",
              //onPressed: Test.onTabTest,
            ),

            OldDesign.padding15,
            SecondaryButton(
              text: '버튼',
              //onPressed: Test.onTabTest,
            ),

            OldDesign.padding15,
            OutlinedPrimaryButton(
                text: '버튼',
                //onPressed: Test.onTabTest
            ),
            OldDesign.padding15,
          ],
        ),
      )
    );
  }
}