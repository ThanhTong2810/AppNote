import 'dart:async';
import 'dart:convert';
import 'package:app_note/controller/note_controller.dart';
import 'package:app_note/controller/user_controller.dart';
import 'package:app_note/helper/shared_preferences_helper.dart';
import 'package:app_note/model/user.dart';
import 'package:app_note/res/images/images.dart';
import 'package:app_note/screen/main_screen/main_screen.dart';
import 'package:app_note/screen/menu_screen/menu_screen.dart';
import 'package:app_note/theme/colors.dart';
import 'package:app_note/utils/utils.dart';
import 'package:app_note/widget/fade_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  final UserController userController=Get.find();
  Timer timer;

  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  ///           OVERRIDE METHODS           ///
  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  @override
  void initState() {
    super.initState();
    onWidgetBuildDone(onBuildDone);
  }

  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logoSize = getScreenWidth(context) / 2;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: FadeContainer(
          child: Image.asset(
            Images.logo,
            width: logoSize,
            height: logoSize,
          ),
        ),
      ),
    );
  }

  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  ///           BUILD METHODS              ///
  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///

  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  ///             OTHER METHODS            ///
  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  onBuildDone() async {
    /// Delay 3 seconds, then navigate to Login screen

    timer=Timer.periodic(Duration(seconds: 2), (timer) async {
      await _loadUserData();
      if (userController.user.value==null) {
        _navigateToLoginScreen();
      } else {
        _navigateToMainScreen();
      }
    });
  }

  _loadUserData() async {
    var user = await SharedPreferencesHelper.getStringValue(
        SharedPreferencesHelper.USER);
    if (user.isNotEmpty) {
      userController.user.value = UserApp.fromJson(jsonDecode(user));
    }
  }

  _navigateToLoginScreen() {
    Get.offAll(LoginScreen());
  }

  _navigateToMainScreen() {
    Get.offAll(MenuMainScreen());
  }
}
