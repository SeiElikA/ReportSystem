import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:report_app/provider/login_provider.dart';
import 'package:report_app/view/register_page.dart';

import '../theme/colorExt.dart';
import '../provider/dart_theme_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginModel = LoginProvider();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark);

    return ChangeNotifierProvider(
        create: (_) => loginModel,
        child: Consumer<LoginProvider>(
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
          Expanded(flex: 8, child: Image.asset("asserts/img_login.png")),
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
                                  const SizedBox(height: 48),

                                  // email field
                                  emailField(),
                                  const SizedBox(height: 38),

                                  // password field
                                  passwordField(),

                                  // login button
                                  loginButton()
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (MediaQuery.of(context).viewInsets.bottom <=
                            100) ...{
                          Positioned(
                            bottom: 20,
                            child: registerButton(),
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
            const SizedBox(height: 48),
            // email field
            emailField(),
            const SizedBox(height: 38),
            // password field
            passwordField(),
            // login button
            loginButton(),

            const SizedBox(height: 32),
            Expanded(
                child: Center(
                    child: Image.asset("asserts/img_login.png",
                        fit: BoxFit.cover))),
            const SizedBox(height: 32),
            registerButton()
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
          Text("Welcome to Report App",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontSize: 32, fontWeight: FontWeight.w600)),
          Text("Login to your account",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 18)),
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
          controller: loginModel.emailController,
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
          controller: loginModel.passwordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !loginModel.isShowPassword,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: Icon(
                  loginModel.isShowPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 24,
                ),
                onPressed: loginModel.isShowPasswordClick),
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  loginButton() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 80, right: 80, top: 50),
      child: TextButton(
          onPressed: () {
            if(loginModel.isLoading) return;
            loginModel.login(context);
          },
          style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              backgroundColor: colorExt.mainColor,
              minimumSize: const Size(double.infinity, 48)),
          child: !loginModel.isLoading
              ? const Text(
                  "Login",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                )
              : loadingCircle()),
    );
  }

  registerButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Need an account? ",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 18),
        ),
        InkWell(
          child: Text(
            "Register",
            style: TextStyle(color: colorExt.mainColor, fontSize: 18),
          ),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RegisterPage()));
          },
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
