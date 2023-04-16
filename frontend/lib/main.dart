import 'package:flutter/material.dart';
import 'package:group_study_app/screens/generate_study_screen.dart';
import 'package:group_study_app/screens/home_screen.dart';
import 'package:group_study_app/screens/notice_detail_screen.dart';
import 'package:group_study_app/screens/notice_list_screen.dart';
import 'package:group_study_app/screens/round_detail_screen.dart';
import 'package:group_study_app/screens/study_detail_screen.dart';

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
                        builder: (context) => HomeScreen()),
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
                        builder: (context) => StudyDetailScreen()),
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
                        builder: (context) => NoticeListScreen()),
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
                        builder: (context) => NoticeDetailScreen()),
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
                        builder: (context) => GenerateStudyScreen()),
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
                        builder: (context) => RoundDetailScreen()),
                  );
                }, child: const Text('Round Detail Screen')
                  , style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50),
                    backgroundColor: Colors.grey,
                  ),
                ),
              ],
            )
        )
    );
  }
}