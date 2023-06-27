import 'package:flutter/material.dart';
import 'package:group_study_app/themes/text_styles.dart';

class RoundDetailRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RoundDetailRoute();
  }
}

class _RoundDetailRoute extends State<RoundDetailRoute> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SingleChildScrollView(
            child: Column(
            children: [

              Text("Asd", style: TextStyles.titleSmall,),
              Text('Round Detail Screen',)
              ],
            ),
        )
    );
  }
}