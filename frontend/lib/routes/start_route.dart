
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
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Character
            Positioned(
              top: 260,
              child: Image.asset(
                Design.characterImagePath,
                scale: 2,),),

            // Cloud
            Positioned(
              top: 488,
              child: Image.asset(
                Design.cloudImagePath,
                color: context.extraColors.inputFieldBackgroundColor,
                scale: 2,),),
            Container(
              margin: const EdgeInsets.only(top: 604),
              color: context.extraColors.inputFieldBackgroundColor,
              width: 420,
              height: 600,),

            // Text And Button
            Container(
              padding: Design.edgePadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Design.padding(92),

                  // Title Text
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      context.local.appDescription,
                      style: TextStyles.startTitle,),),
                  const Spacer(),

                  // start(sing up) button
                  PrimaryButton(
                    text: context.local.start,
                    onPressed: () => Util.pushRoute(context, (context) =>
                    const SignUpRoute()),),
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

                  // bottom margin
                  Design.padding28,
                ],),),
          ],)
      ),
    );
  }
}