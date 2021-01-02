import 'package:app_note/utils/utils.dart';
import 'package:flutter/material.dart';

import 'loader.dart';


class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool isShowIndicator;
  final bool isShadowed;

  LoadingContainer(
      {@required this.child, this.isLoading, this.isShowIndicator=true, this.isShadowed= false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        isLoading
            ? Container(
            width: getScreenWidth(context),
            height: getScreenHeight(context),
            color: isShadowed?Colors.black54:Colors.transparent,
            child: isShowIndicator?Center(child: Loader()):Container())
            : Container()
      ],
    );
  }
}
