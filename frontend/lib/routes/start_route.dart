
import 'package:flutter/material.dart';
import 'package:group_study_app/routes/sign_in_route.dart';
import 'package:group_study_app/utilities/util.dart';

class StartRoute extends StatelessWidget {
  const StartRoute({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: double.infinity,
        child: Column(
          children: [
            ElevatedButton(
                onPressed: null,
                child: Text("회원가입")),

            ElevatedButton(
              onPressed: () =>
                  Util.pushRoute(context, (context) => SignInRoute()),
              child: Text("로그인"),
            ),
          ],
        )
    );
  }
}