

import 'package:flutter/material.dart';

class TestRoute extends StatelessWidget {
  const TestRoute({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          print('tap outside');
        }, child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
            height: 1000,
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey,
              ),
              onTap: () => print('onTap called'),
              onEditingComplete: () => print('editingComplete called'),
              onSubmitted: (value) => print('summitted called'),
            )
        ),
      ),
      ),
    );
  }
}
