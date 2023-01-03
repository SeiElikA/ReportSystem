import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report_app/provider/dart_theme_provider.dart';
import 'package:report_app/theme/dart_theme_styles.dart';
import 'package:report_app/view/adapt/main_page_adapt.dart';
import 'package:report_app/view/login_page.dart';
import 'package:report_app/view/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  Future<bool> isLogin() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool("isLogin") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (context, value, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Styles.themeData(false, context),
          darkTheme: Styles.themeData(true, context),
          home: FutureBuilder<bool>(
            future: isLogin(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                if(snapshot.data!) {
                  return const MainPageAdapt();
                }
              }
              return const LoginPage();
            }
          ),
        ),
      )
    );
  }
}
