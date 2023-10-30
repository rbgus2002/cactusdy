import 'package:flutter/material.dart';
import 'package:group_study_app/models/sign_info.dart';
import 'package:group_study_app/routes/create_notice_route.dart';
import 'package:group_study_app/routes/font_test_route.dart';
import 'package:group_study_app/routes/generate_study_route.dart';
import 'package:group_study_app/routes/home_route.dart';
import 'package:group_study_app/routes/login_route_old.dart';
import 'package:group_study_app/routes/notice_detail_route.dart';
import 'package:group_study_app/routes/notice_list_route.dart';
import 'package:group_study_app/routes/round_detail_route.dart';
import 'package:group_study_app/routes/sign_in_route.dart';
import 'package:group_study_app/routes/sign_up_route.dart';
import 'package:group_study_app/routes/study_detail_route.dart';
import 'package:group_study_app/routes/test_route.dart';
import 'package:group_study_app/routes/work_space_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/utilities/test.dart';
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
        body: Center(
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
                            StudyDetailRoute(studyId: testStudyId,)),
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
                  Util.pushRoute(
                    context, (context) => NoticeDetailRoute(noticeId: 21),);
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
                                roundSeq: -1, roundId: 1, studyId: testStudyId,)),
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
                  Util.pushRoute(context, (context) => CreateNoticeRoute(studyId: testStudyId,));
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
                    MaterialPageRoute(builder: (context) => FontTestRoute()),
                  );
                }, style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 50),
                  backgroundColor: Colors.grey,
                ), child: const Text('font Test Screen')
                  ,
                ),
              ],
            )
        )
    );
  }
}