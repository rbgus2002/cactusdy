
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("DO YOU WANT TO", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 5),),
          RichText(text: TextSpan(text: "STUDY\nWITH\n", style: TextStyle(fontSize: 52, fontWeight: FontWeight.w900, color: Colors.black87),
          children: [ TextSpan(text: "ME?", style: TextStyle(fontSize: 52, fontWeight: FontWeight.w900, color: Colors.blue),), ]))
        ],
      ),
    );
  }
}