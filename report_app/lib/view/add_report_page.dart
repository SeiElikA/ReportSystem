import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:report_app/provider/add_report_provider.dart';
import '../global.dart';

class AddReportPage extends StatefulWidget {
  const AddReportPage({Key? key}) : super(key: key);

  @override
  State<AddReportPage> createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  var addReportModel = AddReportProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => addReportModel,
      child: Consumer<AddReportProvider>(
        builder: (context, value, build) {
          return Scaffold(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? CupertinoColors.black
                : CupertinoColors.systemGroupedBackground,
            appBar: AppBar(
              title: Text("Add Report"),
            ),
            body: SafeArea(
              child: OrientationBuilder(
                builder: (context, orientation) {
                  if (orientation == Orientation.landscape) {
                    return horizontalView();
                  }
                  return verticalView();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  horizontalView() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                Expanded(
                  child: workItemList()
                ),
                addWorkItemFrom()
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              addImageForm(),

              const SizedBox(height: 32),

              sendReportButton()
            ],
          ),
        )
      ],
    );
  }

  verticalView() {
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            workItemList(limitHeight: true),
            addWorkItemFrom(),
            addImageForm(),
            const SizedBox(height: 32),
            sendReportButton()
          ],
        ),
      ),
    );
  }

  Widget itemDetail(String workItem) {
    var item = workItem.split(". ")[1];
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(item),
      onDismissed: (direction) {
        setState(() {
          addReportModel.workItem.remove(item);
        });
      },
      background: Container(
        color: Colors.red,
        child: Icon(Icons.remove_circle_outline),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 12),
      ),
      child: InkWell(
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              workItem,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 18),
            ),
          ),
          trailing: Icon(
            CupertinoIcons.line_horizontal_3,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: item));

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Copy in Clipboard !"),
              duration: Duration(milliseconds: 1500)));
        },
      ),
    );
  }

  sendReportButton() {
    return CupertinoFormSection.insetGrouped(
      footer: const Text("   You can't edit it after send report", style: TextStyle(color: Colors.red),),
      children: [
        Row(
          children: [
            CupertinoButton(child: addReportModel.isLoading ? loadingCircle() : const Text("Send Report"), onPressed: () async {
              if(addReportModel.isLoading) return;
              await addReportModel.sendReport(context);
            }),
            const Spacer()
          ],
        )
      ],
    );
  }

  addImageForm() {
    return CupertinoFormSection.insetGrouped(
        header: Text("   Add work image".toUpperCase()),
        children: [
          if (addReportModel.uploadImg.isNotEmpty) ...{
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: addReportModel.uploadImg
                          .map((e) => Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                right: 12),
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(8)),
                            clipBehavior: Clip.antiAlias,
                            child: Image.file(File(e.path),
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover),
                          ),
                          Positioned(
                              top: 4,
                              right: 14,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    addReportModel.uploadImg
                                        .remove(e);
                                  });
                                },
                                child: const Icon(
                                  CupertinoIcons
                                      .xmark_circle_fill,
                                  color: Colors.red,
                                ),
                              ))
                        ],
                      ))
                          .toList())),
            )
          },
          Row(
            children: [
              const SizedBox(width: 8),
              CupertinoButton(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Add Work Image",
                  ),
                  onPressed: () async {
                    var imgPicker = ImagePicker();
                    var newPhoto = await imgPicker.pickMultiImage();
                    setState(() {
                      addReportModel.uploadImg.addAll(newPhoto);
                    });
                  }),
              const Spacer(),
            ],
          )
        ]);
  }

  addWorkItemFrom() {
    return CupertinoFormSection.insetGrouped(
        header: Text("   Add work item".toUpperCase()),
        children: [
          CupertinoTextFormFieldRow(
            controller: addReportModel.workItemController,
            placeholder: "Input...",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 18),
          ),
          Row(
            children: [
              const SizedBox(width: 8),
              CupertinoButton(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Add Work Item",
                  ),
                  onPressed: () {
                    addReportModel.addWorkItem(context);
                  }),
              const Spacer(),
            ],
          )
        ]);
  }

  workItemList({bool limitHeight = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).brightness == Brightness.dark
              ? CupertinoColors.darkBackgroundGray
              : CupertinoColors.systemBackground),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0, vertical: 12),
        child: ReorderableListView(
            shrinkWrap: limitHeight,
            header: Text("    Work items".toUpperCase()),
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item =
                addReportModel.workItem.removeAt(oldIndex);
                addReportModel.workItem.insert(newIndex, item);
              });
            },
            children: addReportModel.workItem.isEmpty
                ? [
              const ListTile(
                key: Key("Empty"),
                title: Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Empty",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            ]
                : addReportModel.workItem
                .map((e) => itemDetail(
                "${addReportModel.workItem.indexOf(e) + 1}. $e"))
                .toList()),
      ),
    );
  }

  loadingCircle() {
    return (Platform.isAndroid
        ? const SizedBox(
        height: 24,
        width: 24,
        child: const CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ))
        : const CupertinoActivityIndicator(
      color: Colors.white,
    ));
  }
}
