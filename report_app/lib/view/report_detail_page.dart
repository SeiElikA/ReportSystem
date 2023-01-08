import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:photo_view/photo_view.dart';
import 'package:report_app/data/report.dart';
import 'package:report_app/utils/utils.dart';

import '../component/test.dart';
import '../global.dart';

class ReportDetailPage extends StatefulWidget {
  const ReportDetailPage({Key? key, required this.report}) : super(key: key);

  final Report report;

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? CupertinoColors.black
          : CupertinoColors.systemGroupedBackground,
      appBar: AppBar(
        title: const Text("Report Detail"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
            CupertinoFormSection.insetGrouped(
                header: Text("    Work items".toUpperCase()),
                children: widget.report.reportDetail
                    .map((e) => itemDetail(
                        "${widget.report.reportDetail.indexOf(e) + 1}. ${e.content}"))
                    .toList()),
            if (widget.report.imageDetail.isNotEmpty) ...{
              CupertinoFormSection.insetGrouped(
                  header: Text("    Images".toUpperCase()),
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: widget.report.imageDetail
                                .map((e) => Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4, bottom: 4, right: 12.0),
                                      child: CupertinoContextMenu(
                                        actions: [
                                          CupertinoContextMenuAction(
                                            child: Text("Save"),
                                            trailingIcon:
                                                CupertinoIcons.cloud_download,
                                            onPressed: () {
                                              saveImage(baseUrl + e.imgPath);
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                        child: Material(
                                          clipBehavior: Clip.hardEdge,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            clipBehavior: Clip.antiAlias,
                                            child: InkWell(
                                              onTap: () {
                                                imageClick(baseUrl + e.imgPath);
                                              },
                                              child: Hero(
                                                tag: baseUrl + e.imgPath,
                                                child: Image.network(
                                                    baseUrl + e.imgPath,
                                                    width: 140,
                                                    height: 140,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ])
            },
            CupertinoFormSection.insetGrouped(
                header: Text("    Date".toUpperCase()),
                children: [
                  CupertinoFormRow(
                    prefix: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(widget.report.dateTime),
                    ),
                    child: SizedBox(),
                  )
                ]),
          ]),
        ),
      ),
    );
  }

  Widget itemDetail(String workItem) {
    return InkWell(
      child: MyCupertinoFormRow(
        prefix: Expanded(
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(workItem)),
        ),
        child: const SizedBox(
          width: 1,
        ),
      ),
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: workItem.split(". ")[1]));

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Copy in Clipboard !"),
            duration: Duration(milliseconds: 1500)));
      },
    );
  }

  imageClick(String imgUrl) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  saveImage(imgUrl);
                },
                icon: const Icon(Icons.download_outlined))
          ],
        ),
        body: Center(
            child: Hero(
          tag: imgUrl,
          child: PhotoView(
            imageProvider: NetworkImage(imgUrl),
          ),
        )),
      );
    }));
  }

  void saveImage(imgUrl) {
    GallerySaver.saveImage(imgUrl).then((bool? success) {
      if (success == true) {
        showSuccessfulDialog(context, "Save Photo Successful");
        return;
      }

      showErrorDialog(context, "something wrong");
    });
  }
}
