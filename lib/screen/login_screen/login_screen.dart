import 'package:app_note/screen/login_screen/login_form.dart';
import 'package:app_note/theme/colors.dart';
import 'package:app_note/theme/dimens.dart';
import 'package:app_note/utils/utils.dart';
import 'package:app_note/widget/app_logo.dart';
import 'package:app_note/widget/app_text.dart';
import 'package:app_note/widget/gradient_background.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  ///           OVERRIDE METHODS           ///0
  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     return  GestureDetector(
         onTap: ()=>hideKeyboard(context),
         child:  GradientBackground(
             child: Column(
               children: <Widget>[
                 _buildHeader(),
                 SizedBox(
                   height: Dimens.inputFieldMarginTop,
                 ),
                 SizedBox(
                   height: Dimens.inputFieldMarginTop,
                 ),
                 SizedBox(
                   height: Dimens.inputFieldMarginTop,
                 ),
                 LoginForm()
               ],
             )),
       );
  }

  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  ///           BUILD METHODS              ///
  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Padding(
                  padding:  EdgeInsets.only(top: Dimens.getLogoSize(context)),
                  child: Container(
                    child: Center(
                      child: AppText(
                        text: 'Welcome to',
                        color: AppColors.white,
                        textSize: Dimens.headerTextSize,
                      ),
                    ),
                  ),
                )),
            Expanded(
                flex: 1,
                child: Container(
                  child: AppLogo(),
                ))
          ],
        ),
      ),
    );
  }


}
