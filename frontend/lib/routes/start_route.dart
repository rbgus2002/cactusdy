
import 'package:flutter/material.dart';
import 'package:group_study_app/routes/sign_in_route.dart';
import 'package:group_study_app/routes/sign_up_route.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/util.dart';

class StartRoute extends StatelessWidget {
  const StartRoute({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("DO YOU WANT TO", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 5),),
            RichText(text: TextSpan(text: "STUDY\nWITH\n", style: TextStyle(fontSize: 52, fontWeight: FontWeight.w900, color: Colors.black87),
                children: [ TextSpan(text: "ME?", style: TextStyle(fontSize: 52, fontWeight: FontWeight.w900, color: Colors.blue),), ])),

            Design.padding15,
            Design.padding15,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Design.padding5,
                TextButton(
                    onPressed: () => Util.pushRoute(context, (context) => SignUpRoute()),
                    child: Text("회원가입", style: TextStyle(fontSize: 15, fontWeight: TextStyles.medium, decoration: TextDecoration.underline, letterSpacing: 4),)
                  ),
                TextButton(
                    onPressed: () => Util.pushRoute(context, (context) => SignInRoute()),
                    child: Text("로그인", style: TextStyle(fontSize: 15, fontWeight: TextStyles.medium, color: Colors.black, decoration: TextDecoration.underline,letterSpacing: 4),)
                  ),
                Design.padding5,
              ],
            )
          ],
        )
      ),
    );
  }
}