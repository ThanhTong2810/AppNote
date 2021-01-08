import 'package:app_note/controller/app_controller.dart';
import 'package:app_note/controller/category_controller.dart';
import 'package:app_note/controller/note_controller.dart';
import 'package:app_note/controller/user_controller.dart';
import 'package:app_note/localization/flutter_localizations_delegate.dart';
import 'package:app_note/router/routes.dart';
import 'package:app_note/screen/splash_screen.dart';
import 'package:app_note/theme/colors.dart';
import 'package:app_note/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

class LetDoItApp extends StatefulWidget {
  @override
  State<LetDoItApp> createState() => _AppState();
}

class _AppState extends State<LetDoItApp> {
  final AppController appController = Get.put(AppController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appController.getDefaultLanguage();
    return Obx(
      () {
        return GetMaterialApp(
            initialBinding: BindingsBuilder(() {
              Get.put(UserController());
              Get.put(NoteController());
              Get.put(CategoryController());
            }),
            getPages: Routes.route,
            color: AppColors.primary,
            debugShowCheckedModeBanner: false,
            title: '',
            supportedLocales: [
              Locale('vi', 'VN'),
              Locale('en', 'US'),
            ],
            locale: appController.locale.value,
            localizationsDelegates: [
              FlutterLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
                primaryColor: AppColors.primary,
                accentColor: AppColors.primary,
                fontFamily: Fonts.Lato,
                primaryIconTheme: IconThemeData(color: Colors.white)),
            home: SplashScreen());
      },
    );
  }
}
