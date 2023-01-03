import 'package:flutter/material.dart';
import 'package:report_app/view/tablet/main_page_tablet.dart';

import '../mobile/main_page_mobile.dart';

class MainPageAdapt extends StatefulWidget {
  const MainPageAdapt({Key? key}) : super(key: key);

  @override
  State<MainPageAdapt> createState() => _MainPageAdaptState();
}

class _MainPageAdaptState extends State<MainPageAdapt> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if(orientation == Orientation.landscape) {
        return MainPageTablet();
      } else {
        return MainPageMobile();
      }
    });
  }
}
