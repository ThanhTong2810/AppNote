import 'package:app_note/app/app.dart';
import 'package:app_note/theme/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: AppColors.black, statusBarBrightness: Brightness.light));
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
    ]).then((_) {
        runApp(LetDoItApp());
    });
}
