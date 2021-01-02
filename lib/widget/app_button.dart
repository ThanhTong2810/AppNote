import 'package:app_note/theme/colors.dart';
import 'package:app_note/utils/utils.dart';
import 'package:app_note/widget/app_text.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String titleButton;
  final double widthButton;
  final double heightButton;
  final Color textColor;
  final Function onTap;

  const AppButton(this.titleButton,
      {this.widthButton, this.heightButton, this.textColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return _buildAppButton(
        context, titleButton, widthButton, heightButton, textColor);
  }

  Widget _buildAppButton(BuildContext context, String titleButton,
      double widthButton, double heightButton, textColor) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width:
            widthButton != null ? widthButton : getScreenWidth(context) / 1.5,
        height:
            heightButton != null ? heightButton : getScreenWidth(context) / 10,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: AppColors.gradientColorPrimary),
            borderRadius: BorderRadius.circular(10)),
        child: Align(
          alignment: Alignment.center,
          child: AppText(
            color: textColor != null ? textColor : AppColors.white,
            text: titleButton,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
