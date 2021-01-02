import 'package:app_note/theme/colors.dart';
import 'package:app_note/utils/utils.dart';
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  GradientBackground({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: getScreenWidth(context),
          height: getScreenHeight(context),
          decoration: BoxDecoration(
          gradient: LinearGradient(colors: AppColors.gradientColorPrimary)
          ),
          child: this.child),
    );
  }
}
