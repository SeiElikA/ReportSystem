import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:report_app/provider/login_provider.dart';
import 'package:report_app/provider/register_provider.dart';

import '../theme/colorExt.dart';
import '../provider/dart_theme_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final registerModel = RegisterProvider();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark);

    return ChangeNotifierProvider(
        create: (_) => registerModel,
        child: Consumer<RegisterProvider>(
          builder: (context, value, builder) {
            return Scaffold(
                resizeToAvoidBottomInset: false,
                body: OrientationBuilder(
                  builder: (context, orientation) {
                    if (orientation == Orientation.landscape) {
                      return horizontalView();
                    }
                    return verticalView();
                  },
                ));
          },
        ));
  }

  horizontalView() {
    return SafeArea(
      child: Row(
        children: [
          Expanded(flex: 8, child: Image.asset("asserts/img_register.png")),
          Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SizedBox(
                    height: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  titleText(),
                                  const SizedBox(height: 32),

                                  // email field
                                  emailField(),
                                  const SizedBox(height: 38),

                                  // name field
                                  nameField(),
                                  const SizedBox(height: 38),

                                  // password field
                                  passwordField(),
                                  const SizedBox(height: 38),
                                  // confirm password field
                                  confirmPasswordField(),

                                  // login button
                                  registerButton()
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (MediaQuery.of(context).viewInsets.bottom <=
                            100) ...{
                          Positioned(
                            bottom: 20,
                            child: loginButton(),
                          )
                        },
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  verticalView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText(),
            const SizedBox(height: 32),
            // email field
            emailField(),
            const SizedBox(height: 24),
            // name field
            nameField(),
            const SizedBox(height: 24),
            // password field
            passwordField(),
            const SizedBox(height: 24),
            // confirm password field
            confirmPasswordField(),

            // login button
            registerButton(),

            const SizedBox(height: 32),
            Expanded(
                child: Center(
                    child: Image.asset("asserts/img_register.png",
                        fit: BoxFit.cover))),
            const SizedBox(height: 32),
            loginButton()
          ],
        ),
      ),
    );
  }

  titleText() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_rounded)),
              Text("Register",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 32, fontWeight: FontWeight.w600)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text("Register an account to use report app",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 18)),
          ),
        ]);
  }

  emailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Text("Email",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 20)),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: registerModel.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  nameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Text("Name",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 20)),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: registerModel.nameController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Text("Password",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 20)),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: registerModel.passwordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !registerModel.isShowPassword,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: Icon(
                  registerModel.isShowPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 24,
                ),
                onPressed: registerModel.isShowPasswordClick),
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  confirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Text("Confirm Password",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 20)),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: registerModel.confirmPasswordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  registerButton() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 80, right: 80, top: 50),
      child: TextButton(
          onPressed: () {
            if (registerModel.isLoading) return;
            registerModel.registerClick(context);
          },
          style: TextButton.styleFrom(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              backgroundColor: colorExt.mainColor,
              minimumSize: const Size(double.infinity, 48)),
          child: !registerModel.isLoading
              ? const Text(
                  "Register",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                )
              : loadingCircle()),
    );
  }

  loginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 18),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Login",
            style: TextStyle(color: colorExt.mainColor, fontSize: 18),
          ),
        )
      ],
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
