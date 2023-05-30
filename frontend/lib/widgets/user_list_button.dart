import 'package:flutter/cupertino.dart';

import '../models/user.dart';
import 'buttons/circle_button.dart';

class UserListButton extends StatelessWidget {
  final List<User> userList;
  final onTap;
  final double scale;

  const UserListButton({
    Key? key,
    required this.userList,
    this.onTap,
    required this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (User user in userList)
            Container(
              margin: const EdgeInsets.fromLTRB(1, 0, 3, 1),
              child: CircleButton(scale: scale, child: null, onTap: onTap),
            )
        ],
      ),
    );
  }
}
