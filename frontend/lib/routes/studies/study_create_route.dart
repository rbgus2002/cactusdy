

import 'package:flutter/material.dart';
import 'package:groupstudy/models/study.dart';
import 'package:groupstudy/routes/studies/study_create_page1.dart';
import 'package:groupstudy/routes/studies/study_create_page2.dart';
import 'package:groupstudy/routes/studies/study_create_page3.dart';
import 'package:groupstudy/routes/studies/study_detail_route.dart';
import 'package:groupstudy/themes/color_styles.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/charts/progress_bar_widget.dart';
import 'package:image_picker/image_picker.dart';

class StudyCreateRoute extends StatefulWidget {
  const StudyCreateRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<StudyCreateRoute> createState() => _StudyCreateRouteState();
}

class _StudyCreateRouteState extends State<StudyCreateRoute> {
  final GlobalKey<ProgressBarWidgetState> _progressController = GlobalKey();

  String _studyName = "";
  String _studyDetail = "";
  Color _studyColor = ColorStyles.mainColor;
  XFile? _profileImage;

  final int _pageCount = 3;
  int _page = 1;

  bool _isProcessing = false;

  late final int _newStudyId;
  late final String _invitingCode;

  late ProgressBarWidget progressBarWidget;

  @override
  void initState() {
    super.initState();

    progressBarWidget = ProgressBarWidget(
      key: _progressController,
      initProgress: _getProgress(),);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: progressBarWidget),),
        body: SingleChildScrollView(
          padding: Design.edgePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Design.padding4,
              Text(
                (_page == 3)?
                  context.local.startStudyWithFriend :
                  context.local.setStudyInfo,
                style: TextStyles.head2.copyWith(
                  color: context.extraColors.grey800,),),

              (_page == 1) ?
                StudyCreatePage1(
                  studyName: _studyName, studyDetail: _studyDetail,
                  getNext: _getStudyNameAndDetail,) :
              (_page == 2) ?
                StudyCreatePage2(
                  getNext: _getStudyColorAndImage,) :
              (_page == 3) ?
                StudyCreatePage3(
                  studyName: _studyName,
                  invitingCode: _invitingCode) : const SizedBox(),
            ],),),
      ),
    );
  }

  void _getStudyNameAndDetail(String studyName, String studyDetail) {
    if (_page == 1) {
      _studyName = studyName;
      _studyDetail = studyDetail;

      _pageRouteTo(2);
    }
  }

  void _getStudyColorAndImage(Color studyColor, XFile? profileImage) {
    if (_page == 2) {
      _studyColor = studyColor;
      _profileImage = profileImage;

      _createStudy();
    }
  }

  void _pageRouteTo(int page) {
    setState(() {
      _page = page;
      _progressController.currentState!.progress = _getProgress();
    });
  }

  void _createStudy() async {
    if (!_isProcessing) {
      _isProcessing = true;

      try {
        await Study.createStudy(
            studyName: _studyName,
            studyDetail: _studyDetail,
            studyColor: _studyColor,
            studyImage: _profileImage).then((map) {
              _newStudyId = map['studyId'];
              _invitingCode = map['inviteCode'];

              _pageRouteTo(3);
            });
      } on Exception catch(e) {
        if (mounted) {
          Toast.showToast(
              context: context,
              message: Util.getExceptionMessage(e));
        }
      }

      _isProcessing = false;
    }
  }


  Future<bool> _onBack() async {
    // #Case: Study is created => view study detail
    if (_page >= _pageCount) {
      _viewStudyDetail();
      return true;
    }

    // #Case: back page
    else if (_page > 1) {
      _pageRouteTo(_page - 1);
      return false;
    }

    // #Case: first page => cancel creating study
    return true;
  }

  void _viewStudyDetail() async {
    try {
      await Study.getStudySummary(_newStudyId).then((study) =>
          Util.pushRoute(context, (context) =>
              StudyDetailRoute(study: study)));
    } on Exception catch(e) {
      if (context.mounted) {
        Toast.showToast(
            context: context,
            message: Util.getExceptionMessage(e));
      }
    }
  }

  double _getProgress() {
    return _page / _pageCount;
  }
}

