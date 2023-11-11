import 'dart:async';

import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/themes/old_text_styles.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';

class UserProfileDialog {
  static const double borderRadius = 30;
  static Future<dynamic> showProfileDialog(BuildContext context, int userId) {
    int studyId = 1; //< FIXME
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          insetPadding: OldDesign.edge15,
          content: Container(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleButton(url: "", onTap: null, size: 70), //< FIXME
                      OldDesign.padding15,
                      Flexible(child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("NickName", style: OldTextStyles.titleLarge,),
                          Text("Adittional comment", style: OldTextStyles.bodyLarge),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //StudyGroupTag(color: ColorStyles.red, name: "Algorithm",),
                                //StudyGroupTag(color: ColorStyles.orange, name: "TOEIC"),

                                //StudyGroupTag(color: ColorStyles.green, name: "Love"),
                              ],
                            ),
                          )
                        ],
                      )
                      )
                    ]
                  ),
                  OldDesign.padding15,

                  /*
                  const Text("HomeWork Rate", style: TextStyles.titleSmall, textAlign: TextAlign.start),
                  BarChart(percentInfos: [PercentInfo(percent: 0.89, color: Colors.blue)]),
                  Design.padding15,

                  const Text("Attendance Rate", style: TextStyles.titleSmall, textAlign: TextAlign.start),
                  BarChart(percentInfos: [
                    PercentInfo(percent: 0.83, color: ColorStyles.green),
                    PercentInfo(percent: 0.12, color: ColorStyles.orange),
                    PercentInfo(percent: 0.05, color: ColorStyles.red),
                  ]),


                  Design.padding15,

                   */

                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(onPressed: () => User.notifyParticipant(userId, studyId),
                        child: Text("Stab!", style: OldTextStyles.titleLarge,), style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius),),
                          minimumSize: const Size(120, borderRadius),
                          foregroundColor: Colors.black,//< FIXME
                      ),),
                      OutlinedButton(onPressed: (){},
                        child: Text("Kick!", style: OldTextStyles.titleLarge,), style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
                          minimumSize: const Size(120, borderRadius),
                          //foregroundColor: < FIXME
                        ),),
                      ],
                  )

                ],
              ),
          ),
        );
      }
    );
  }
}