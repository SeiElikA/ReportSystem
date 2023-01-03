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

import '../main_page.dart';
import '../report_detail_page.dart';

class MainPageTablet extends StatefulWidget {
  const MainPageTablet({Key? key}) : super(key: key);

  @override
  State<MainPageTablet> createState() => _MainPageTabletState();
}

class _MainPageTabletState extends State<MainPageTablet> {
  Report? report;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark);

    return Scaffold(
      body: Row(children: [
        Expanded(
            flex: 2,
            child: MainPage(
              onReportItemClick: (report) {
                setState(() {
                  this.report = report;
                });
              },
            )),
        Expanded(
            flex: 3,
            child: report != null
                ? ReportDetailPage(report: report!)
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset("asserts/img_select.png", width: MediaQuery.of(context).size.width * 0.3),
                        const SizedBox(height: 24),
                        Text("Select a report from left list", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),)
                      ],
                  )))
      ]),
    );
  }
}
