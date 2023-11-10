
import 'package:flutter/material.dart';
import 'package:group_study_app/routes/sign_routes/sign_in_route.dart';
import 'package:group_study_app/routes/sign_routes/sign_up_verify_route.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/primary_button.dart';
import 'package:group_study_app/widgets/logo.dart';

class StartRoute extends StatelessWidget {
  const StartRoute({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: Design.edgePadding,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // logo
            const Expanded(child: Logo()),

            // start(sing up) button
            PrimaryButton(
              text: context.local.start,
              onPressed: () => Util.pushRoute(context, (context) => const SignUpRoute()),
            ),
            Design.padding4,

            // sing in button
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.local.alreadyHaveAnAccount,
                  style: TextStyles.head5.copyWith(color: context.extraColors.grey500),),

                TextButton(
                  onPressed: () => Util.pushRoute(context, (context) => const SignInRoute()),
                  child : Text(context.local.signIn),),
              ],),

            Design.padding28,
          ],
        )
      ),
    );
  }
}