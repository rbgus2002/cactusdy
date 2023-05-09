import 'package:flutter/cupertino.dart';

import '../models/user.dart';
import 'circle_button.dart';

class UserList extends StatelessWidget {
  final List<User> userList;
  final onTap;


  const UserList({
    Key? key,
    required this.userList,
    this.onTap,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          for(User user in userList)
            CircleButton(scale: 45.0, child: null, onTap: onTap), // TODO : image null 처리 방법 고안
        ],
      ),
    );
  }

}