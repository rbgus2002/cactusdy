import 'package:flutter/material.dart';
import 'package:group_study_app/routes/create_notice_route.dart';
import 'package:group_study_app/routes/generate_study_route.dart';
import 'package:group_study_app/routes/home_route.dart';
import 'package:group_study_app/routes/login_route.dart';
import 'package:group_study_app/routes/notice_detail_route.dart';
import 'package:group_study_app/routes/notice_list_route.dart';
import 'package:group_study_app/routes/round_detail_route.dart';
import 'package:group_study_app/routes/study_detail_route.dart';
import 'package:group_study_app/routes/work_space_route.dart';

void main() {
  runApp(MaterialApp(
    title: 'asd',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center (
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(height: 15,),
                ElevatedButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeRoute()),
                  );
                }, child: const Text('HomeScreen')
                  , style: ElevatedButton.styleFrom(
                      fixedSize: Size(300, 50),
                      backgroundColor: Colors.grey,
                  ),
                ),

                Container(height: 15,),
                ElevatedButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudyDetailRoute()),
                  );
                }, child: const Text('Study Detail Screen')
                , style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50),
                    backgroundColor: Colors.grey,
                  ),
                ),

                Container(height: 15,),
                ElevatedButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NoticeListRoute()),
                  );
                }, child: const Text('Notice List Screen')
                  , style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50),
                    backgroundColor: Colors.grey,
                  ),
                ),

                Container(height: 15,),
                ElevatedButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NoticeDetailRoute(21)),
                  );
                }, child: const Text('Notice Detail Screen')
                  , style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50),
                    backgroundColor: Colors.grey,
                  ),
                ),

                Container(height: 15,),
                ElevatedButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GenerateStudyRoute()),
                  );
                }, child: const Text('Generate Study Screen')
                  , style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50),
                    backgroundColor: Colors.grey,
                  ),
                ),
                Container(height: 15,),
                ElevatedButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RoundDetailRoute()),
                  );
                }, child: const Text('Round Detail Screen')
                  , style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50),
                    backgroundColor: Colors.grey,
                  ),
                ),

                Container(height: 15,),
                ElevatedButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WorkSpaceRoute()),
                  );
                }, child: const Text('Work Space Screen')
                  , style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50),
                    backgroundColor: Colors.grey,
                  ),
                ),

                Container(height: 15,),
                ElevatedButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginTest()),
                  );
                }, style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 50),
                    backgroundColor: Colors.grey,
                  ), child: const Text('Login Test Screen')
                  ,
                ),

                Container(height: 15,),
                ElevatedButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateNoticeRoute()),
                  );
                }, style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 50),
                  backgroundColor: Colors.grey,
                ), child: const Text('Create Notice Screen')
                  ,
                ),
              ],

            )
        )
    );
  }
}

