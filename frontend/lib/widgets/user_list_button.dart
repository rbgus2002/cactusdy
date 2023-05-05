import 'package:flutter/cupertino.dart';

import '../models/user.dart';
import '../utilities/test.dart';
import 'circle_button.dart';

class UserList extends StatelessWidget {
  // TODO : models(?)에 MEMBER 객체 생성
  final List<User> userList;
  final onTap;


  const UserList({
    Key? key,
    required this.userList,
    this.onTap,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for(User user in userList)
              CircleButton(scale: 65.0, image: null, onTap: onTap) // TODO : image null 처리 방법 고안
          ],
        ),
      ),
    );
  }

}