import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

void showErrorDialog(BuildContext context, String msg,
    {String buttonText = "OK", Function()? onTap}) {
  if (Platform.isAndroid) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(msg),
            actions: [
              TextButton(
                child: Text(buttonText),
                onPressed: () {
                  if (onTap != null) {
                    onTap();
                  }
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  } else if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Error"),
            content: Text(msg),
            actions: [
              CupertinoButton(
                child: Text(buttonText),
                onPressed: () {
                  if (onTap != null) {
                    onTap();
                  }
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}

void showSuccessfulDialog(BuildContext context, String msg,
    {String buttonText = "OK", Function()? onTap}) {
  if (Platform.isAndroid) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Successful"),
            content: Text(msg),
            actions: [
              TextButton(
                child: Text(buttonText),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onTap != null) {
                    onTap();
                  }
                },
              )
            ],
          );
        });
  } else if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Successful"),
            content: Text(msg),
            actions: [
              CupertinoButton(
                child: Text(buttonText),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onTap != null) {
                    onTap();
                  }
                },
              )
            ],
          );
        });
  }
}
