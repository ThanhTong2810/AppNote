import 'package:app_note/res/images/images.dart';
import 'package:app_note/theme/dimens.dart';
import 'package:app_note/widget/fade_container.dart';
import 'package:flutter/material.dart';
class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logoSize = Dimens.getLogoSize(context);
    return Padding(
      padding: EdgeInsets.only(top: logoSize),
      child: FadeContainer(child: Image.asset(Images.logo, width: logoSize,)),
    );
  }
}
