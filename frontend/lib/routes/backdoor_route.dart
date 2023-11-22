import 'package:flutter/material.dart';
import 'package:group_study_app/models/notice.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/routes/notices/notice_create_route.dart';
import 'package:group_study_app/routes/design_test_route.dart';
import 'package:group_study_app/routes/generate_study_route.dart';
import 'package:group_study_app/routes/home_route.dart';
import 'package:group_study_app/routes/notices/notice_detail_route.dart';
import 'package:group_study_app/routes/notices/notice_list_route.dart';
import 'package:group_study_app/routes/round_detail_route.dart';
import 'package:group_study_app/routes/sign_routes/sign_in_route.dart';
import 'package:group_study_app/routes/sign_routes/sign_up_detail_route.dart';
import 'package:group_study_app/routes/sign_routes/sign_up_verify_route.dart';
import 'package:group_study_app/routes/studies/study_detail_route.dart';
import 'package:group_study_app/routes/test_route.dart';
import 'package:group_study_app/utilities/util.dart';

class BackdoorRoute extends StatelessWidget {
  final int testStudyId = 1; //< FIXME Caution!

  const BackdoorRoute({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(height: 15,),
                ElevatedButton(onPressed: () {
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
                        builder: (context) =>
                            StudyDetailRoute(
                              study: Study(color: Colors.red, studyName: "ASD",picture: "", detail: "asd", studyId: 1, hostId: 1),
                            )),
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
                        builder: (context) => NoticeListRoute(studyId: testStudyId,)),
                  );
                }, child: const Text('Notice List Screen')
                  , style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50),
                    backgroundColor: Colors.grey,
                  ),
                ),

                Container(height: 15,),
                ElevatedButton(onPressed: () {
                  Notice.getNotice(21).then((notice) =>
                  Util.pushRoute(
                    context, (context) => NoticeDetailRoute(notice: notice, studyId: 1,),));
                },
                  child: const Text('Notice Detail Screen')
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
                        builder: (context) =>
                            RoundDetailRoute(
                                roundSeq: -1, roundId: 1, study: Study(studyId: 1, studyName: "TEST", color: Colors.red, detail: "idk", picture: "", hostId: 1))),
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
                        builder: (context) => SignInRoute()),
                  );
                }, style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 50),
                  backgroundColor: Colors.grey,
                ), child: const Text('Login Test Screen')
                  ,
                ),

                Container(height: 15,),
                ElevatedButton(onPressed: () {
                  Util.pushRoute(context, (context) => NoticeCreateRoute(studyId: testStudyId,));
                }, style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 50),
                  backgroundColor: Colors.grey,
                ), child: const Text('Create Notice Screen')
                  ,
                ),

                Container(height: 15,),
                ElevatedButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignUpRoute()),
                  );
                }, child: const Text('Sign Up Screen')
                  , style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50),
                    backgroundColor: Colors.grey,
                  ),
                ),


                Container(height: 15,),
                ElevatedButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TestRouteState()),
                  );
                }, style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 50),
                  backgroundColor: Colors.grey,
                ), child: const Text('Test Screen')
                  ,
                ),

                Container(height: 15,),
                ElevatedButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DesignTestRoute()),
                  );
                }, style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 50),
                  backgroundColor: Colors.grey,
                ), child: const Text('font Test Screen')
                  ,
                ),
                
                Container(height: 15,),
                ElevatedButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpDetailRoute(phoneNumber: '01055923653', password: '1234')),
                  );
                }, style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 50),
                  backgroundColor: Colors.grey,
                ), child: const Text('sign up details Screen')
                  ,
                ),
              ],
            )
        )
    );
  }
}