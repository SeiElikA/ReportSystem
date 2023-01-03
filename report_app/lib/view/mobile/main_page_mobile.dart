import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:report_app/data/report.dart';
import 'package:report_app/global.dart';
import 'package:report_app/model/main_model.dart';
import 'package:report_app/provider/main_provider.dart';
import 'package:report_app/theme/colorExt.dart';
import 'package:report_app/view/report_detail_page.dart';

import '../main_page.dart';

class MainPageMobile extends StatefulWidget {
  const MainPageMobile({Key? key}) : super(key: key);

  @override
  State<MainPageMobile> createState() => _MainPageMobileState();
}

class _MainPageMobileState extends State<MainPageMobile> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark);
    return Scaffold(
      body: MainPage(onReportItemClick: (report) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportDetailPage(report: report)));
      }),
    );
  }
}
