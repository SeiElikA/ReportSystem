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
import 'package:report_app/view/add_report_page.dart';
import 'package:report_app/view/mobile/main_page_mobile.dart';
import 'package:report_app/view/tablet/main_page_tablet.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.onReportItemClick}) : super(key: key);

  final Function(Report) onReportItemClick;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late ScrollController _hideButtonController;
  var mainModel = MainProvider();

  var _isVisible = false;

  @override
  initState() {
    super.initState();
    //region set floatActionButton
    _isVisible = true;
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
    //endregion

    mainModel.setReportList(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => mainModel,
      child: Consumer<MainProvider>(builder: (context, value, builder) {
        return Scaffold(
          floatingActionButton: floatActionButton(),
          backgroundColor: Theme.of(context).backgroundColor,
          body: NestedScrollView(
              physics: const BouncingScrollPhysics(),
              controller: _hideButtonController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 120.0,
                    pinned: true,
                    backgroundColor: Theme.of(context).backgroundColor,
                    flexibleSpace: FlexibleSpaceBar(
                        titlePadding:
                            const EdgeInsets.only(left: 20, bottom: 8),
                        centerTitle: false,
                        title: Text(
                          "Report",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontSize: 24, fontWeight: FontWeight.w600),
                        )),
                    actions: [logoutButton()],
                  ),
                ];
              },
              body: RefreshIndicator(
                  onRefresh: () async {
                    await mainModel.setReportList(context, showLoading: false);
                  },
                  child: SingleChildScrollView(
                    child: reportList(),
                  ))),
        );
      }),
    );
  }

  floatActionButton() {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 200),
      offset: _isVisible ? Offset.zero : Offset(0, 2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _isVisible ? 1 : 0,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: addReportClick,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  reportList() {
    if (mainModel.reportList.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "asserts/img_empty.png",
              width: MediaQuery.of(context).size.width * 0.4,
            ),
            const SizedBox(height: 16),
            Text("Click button to add your first report",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 18))
          ],
        ),
      );
    } else if (mainModel.isLoading) {
      return Center(
          child: LoadingIndicator(
        indicatorType: Indicator.ballClipRotateMultiple,
        colors: [Theme.of(context).primaryColor],
      ));
    }
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(children: [
        for (var item in mainModel.reportList) ...{reportItem(item)}
      ]),
    );
  }

  reportItem(Report item) {
    bool isToday =
        item.dateTime == DateFormat('yyyy-MM-dd').format(DateTime.now());

    return IntrinsicHeight(
      child: Row(children: [
        Stack(
          children: [
            // dot
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 32,
                  height: 32,
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                          color: isToday
                              ? Theme.of(context).primaryColor
                              : colorExt.bodySmallColorDark,
                          width: 4)),
                  child: isToday
                      ? Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(999)),
                        )
                      : const SizedBox(),
                ),
              ],
            ),

            // line
            if (mainModel.reportList.indexOf(item) !=
                mainModel.reportList.length - 1) ...{
              Positioned.fill(
                top: 30,
                left: 14,
                right: 14,
                bottom: 0,
                child: Container(
                  width: 12,
                  decoration: BoxDecoration(
                      color: isToday
                          ? Theme.of(context).primaryColor
                          : colorExt.bodySmallColorDark),
                ),
              )
            }
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerLeft,
                height: 32,
                child: Text(
                  item.dateTime.replaceAll("-", "."),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
                )),
            SizedBox(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 4,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    widget.onReportItemClick(item);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SelectableText(
                                    item.reportDetail
                                        .map((e) =>
                                            "${item.reportDetail.indexOf(e) + 1}. ${e.content}")
                                        .toList()
                                        .join("\n"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontSize: 18)),
                                if (item.imageDetail.isNotEmpty) ...{
                                  const SizedBox(height: 8)
                                },
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: item.imageDetail
                                        .map((e) => Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  clipBehavior: Clip.antiAlias,
                                                  child: Image.network(
                                                      baseUrl + e.imgPath,
                                                      width: 64,
                                                      height: 64,
                                                      fit: BoxFit.cover)),
                                            ))
                                        .toList(),
                                  ),
                                )
                              ]),
                        ),
                        const RotatedBox(
                            quarterTurns: 2,
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              size: 16,
                              color: Colors.grey,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12)
          ],
        ))
      ]),
    );
  }

  logoutButton() {
    return IconButton(
        onPressed: () {
          if (Platform.isIOS) {
            showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Do you want logout?"),
                    actions: [
                      CupertinoButton(
                          child: const Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      CupertinoButton(
                          child: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () async {
                            await mainModel.logoutClick(context);
                          }),
                    ],
                  );
                });
          }
        },
        icon: Icon(
          Icons.logout_outlined,
          color: Theme.of(context).primaryColor,
        ));
  }

  void addReportClick() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AddReportPage()))
        .then((value) => mainModel.setReportList(context));
  }
}
