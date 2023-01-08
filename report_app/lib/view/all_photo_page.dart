import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:report_app/model/all_photo_model.dart';
import 'package:report_app/provider/all_photo_provider.dart';

import '../global.dart';
import '../utils/utils.dart';

class AllPhotoPage extends StatefulWidget {
  const AllPhotoPage({super.key});

  @override
  State<AllPhotoPage> createState() => _AllPhotoPageState();
}

class _AllPhotoPageState extends State<AllPhotoPage> {
  var model = AllPhotoProvider();

  @override
  void initState() {
    super.initState();
    model.getAllImage(context);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark);

    return ChangeNotifierProvider(
      create: ((context) => model),
      child: Consumer<AllPhotoProvider>(
        builder: (context, value, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Images",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 28, fontWeight: FontWeight.w600),
                ),
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
              ),
              body: SafeArea(
                child: body(),
              ));
        },
      ),
    );
  }

  Widget body() {
    if (model.isLoading) {
      return Center(
        child: loadingCircle(),
      );
    } else if (model.allImage.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Image.asset(
                "asserts/img_empty.png",
              ),
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
    }

    return RefreshIndicator(
      onRefresh: () async {
        await model.getAllImage(context);
      },
      child: GridView.count(
          physics: const BouncingScrollPhysics(),
          childAspectRatio: 1,
          crossAxisCount: getCrossAxisCount(),
          crossAxisSpacing: 2.5,
          mainAxisSpacing: 2.5,
          children: model.allImage
              .map((e) => imgView(e.imgPath, 200))
              .toList()
              .reversed
              .toList()),
    );
  }

  int getCrossAxisCount() {
    if (Orientation.landscape == MediaQuery.of(context).orientation) {
      return 5;
    } else {
      if (MediaQuery.of(context).size.width > 700) {
        return 5;
      } else {
        return 3;
      }
    }
  }

  Widget imgView(String url, double size) {
    return CupertinoContextMenu(
      actions: [
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.cloud_download,
          onPressed: () {
            saveImg(url);
            Navigator.of(context).pop();
          },
          child: const Text("Save"),
        )
      ],
      child: Material(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  actions: [
                    IconButton(
                        onPressed: () {
                          saveImg(url);
                        },
                        icon: const Icon(Icons.download_outlined))
                  ],
                ),
                body: Center(
                    child: Hero(
                  tag: url,
                  child: PhotoView(
                    imageProvider: NetworkImage(baseUrl + url),
                    loadingBuilder: (context, event) {
                      return loadingCircle();
                    },
                  ),
                )),
              );
            }));
          },
          child: Hero(
            tag: url,
            child: Image.network(
              baseUrl + url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                var loading = loadingProgress.cumulativeBytesLoaded;
                var total = loadingProgress.expectedTotalBytes ?? -1;
                if (Platform.isAndroid) {
                  if (loading != -1 && total != -1) {
                    return Container(
                        height: size,
                        width: size,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: CircularProgressIndicator(
                          value: loading / total,
                        ));
                  }
                  return Container(
                      height: size,
                      width: size,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: const CircularProgressIndicator());
                } else {
                  return Container(
                      height: size,
                      width: size,
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: const CupertinoActivityIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void saveImg(url) {
    GallerySaver.saveImage(baseUrl + url).then((bool? success) {
      if (success == true) {
        showSuccessfulDialog(context, "Save Photo Successful");
        return;
      }

      showErrorDialog(context, "something wrong");
    });
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
