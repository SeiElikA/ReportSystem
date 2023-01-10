import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:report_app/data/history_report.dart';
import 'package:report_app/data/report.dart';
import 'package:report_app/provider/report_history_provider.dart';
import 'package:report_app/theme/colorExt.dart';
import 'package:report_app/view/all_photo_page.dart';
import 'package:report_app/view/report_detail_page.dart';

import '../global.dart';

class ReportHistoryPage extends StatefulWidget {
  const ReportHistoryPage({super.key});

  @override
  State<ReportHistoryPage> createState() => _ReportHistoryState();
}

class _ReportHistoryState extends State<ReportHistoryPage> {
  var model = ReportHistoryProvider();

  @override
  void initState() {
    super.initState();
    model.getAllData(context);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark);

    return ChangeNotifierProvider(
      create: (context) => model,
      child: Consumer<ReportHistoryProvider>(
        builder: ((context, value, child) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                  "Report History",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 28, fontWeight: FontWeight.w600),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.photo_on_rectangle,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AllPhotoPage()));
                    },
                  )
                ],
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              body: SafeArea(
                child: RefreshIndicator(
                    onRefresh: () async {
                      await model.getAllData(context);
                    },
                    child: model.isLoading
                        ? Center(child: loadingCircle())
                        : (model.dataList.isEmpty
                            ? const Center(child: Text("Report History Empty"))
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: filterWidget(),
                                  ),
                                  Expanded(
                                    child: Scrollbar(child: bodyList()),
                                  ),
                                ],
                              ))),
              ));
        }),
      ),
    );
  }

  Widget bodyList() {
    var widgetList = model.dateTimeList
        .map((e) =>
            model.filterList.where((element) => element.dateTime == e).toList())
        .toList()
        .map((e) => reportItem(e))
        .toList();

    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: widgetList.length,
        itemBuilder: ((context, index) {
          return widgetList[index];
        }));
  }

  void filterData() {
    var name = model.accountSelection;
    var date = model.dateTimeSelection;
    if (name == "All" && date == "All") {
      setState(() {
        model.filterList = model.dataList;
      });
    } else if (name == "All") {
      setState(() {
        model.filterList = model.dataList
            .where((element) => element.dateTime == date)
            .toList();
      });
    } else if (date == "All") {
      setState(() {
        model.filterList = model.dataList
            .where((element) => element.account?.name == name)
            .toList();
      });
    } else {
      setState(() {
        model.filterList = model.dataList
            .where((element) =>
                element.account?.name == name && element.dateTime == date)
            .toList();
      });
    }

    setState(() {
      model.dateTimeList = [
        ...{...model.filterList.map((e) => e.dateTime).toList()}
      ];

      model.dateTimeList.sort(((a, b) {
        var dateFormat = DateFormat("yyyy-MM-dd");
        var first = dateFormat.parse(a);
        var second = dateFormat.parse(b);
        return second.compareTo(first);
      }));
    });
  }

  Widget reportItem(List<HistoryReport> filterList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Datetime
        Text(
          filterList.isEmpty
              ? "Null"
              : filterList.first.dateTime.replaceAll("-", " . "),
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        // Every one report content
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: Row(children: [
              for (var data in filterList) ...{reportItemDetail(data)},
            ]),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget dateFilterDropDownMenu() {
    return DropdownButton(
        value: model.dateTimeSelection,
        isExpanded: true,
        items: model.dropDownDateTimeList
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (value) async {
          setState(() {
            model.dateTimeSelection = value as String;
          });
          filterData();
        });
  }

  Widget accountFilterDropDownMenu() {
    return DropdownButton(
        isExpanded: true,
        value: model.accountSelection,
        items: model.accountList
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (value) async {
          setState(() {
            model.accountSelection = value as String;
          });
          filterData();
        });
  }

  Widget filterWidget() {
    return Row(
      children: [
        Expanded(child: accountFilterDropDownMenu()),
        const SizedBox(width: 12),
        Expanded(child: dateFilterDropDownMenu()),
        if (MediaQuery.of(context).orientation == Orientation.landscape) ...{
          const Expanded(
            flex: 2,
            child: SizedBox(),
          )
        }
      ],
    );
  }

  reportItemDetail(HistoryReport item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // name
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            item.account?.name ?? "Null",
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 20),
          ),
        ),

        const SizedBox(height: 4),

        // item content
        Expanded(
          child: SizedBox(
            width: 300,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  var report = Report(item.id, item.dateTime, item.reportDetail,
                      item.imageDetail);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) => ReportDetailPage(report: report)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
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
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          clipBehavior: Clip.antiAlias,
                                          child: Image.network(
                                            baseUrl + e.imgPath,
                                            width: 64,
                                            height: 64,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              var loading = loadingProgress
                                                  .cumulativeBytesLoaded;
                                              var total = loadingProgress
                                                      .expectedTotalBytes ??
                                                  -1;
                                              if (Platform.isAndroid) {
                                                if (loading != -1 &&
                                                    total != -1) {
                                                  return Container(
                                                      height: 64,
                                                      width: 64,
                                                      padding:
                                                          EdgeInsets.all(16),
                                                      decoration: BoxDecoration(
                                                          color: Theme.of(
                                                                  context)
                                                              .backgroundColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child:
                                                          CircularProgressIndicator(
                                                        value: loading / total,
                                                      ));
                                                }
                                                return Container(
                                                    height: 64,
                                                    width: 64,
                                                    padding: EdgeInsets.all(16),
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .backgroundColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child:
                                                        const CircularProgressIndicator());
                                              } else {
                                                return Container(
                                                    height: 64,
                                                    width: 64,
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .backgroundColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child:
                                                        const CupertinoActivityIndicator());
                                              }
                                            },
                                          )),
                                    ))
                                .toList(),
                          ),
                        )
                      ]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  loadingCircle() {
    return (Platform.isAndroid
        ? SizedBox(
            child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ))
        : const CupertinoActivityIndicator());
  }
}
