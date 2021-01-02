import 'package:app_note/localization/flutter_localizations.dart';
import 'package:app_note/theme/colors.dart';
import 'package:app_note/theme/dimens.dart';
import 'package:app_note/widget/app_text.dart';
import 'package:flutter/material.dart';

class AndroidDialog extends StatefulWidget {
  final String title;
  final String content;
  final Function cancel;
  final Function confirm;

  const AndroidDialog(
      {Key key, this.title, this.content, this.cancel, this.confirm})
      : super(key: key);

  @override
  _AndroidDialogState createState() => _AndroidDialogState();
}

class _AndroidDialogState extends State<AndroidDialog> {
  bool enable;

  @override
  void initState() {
    enable = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: AppText(
        text: widget.title ?? '',
        color: AppColors.black,
      ),
      content: AppText(
        text: widget.content ?? '',
        color: AppColors.black,
        textSize: Dimens.errorTextSize,
      ),
      actions: <Widget>[
        widget.cancel != null
            ? FlatButton(
                onPressed: widget.cancel,
                child: AppText(
                  text: FlutterLocalizations.of(context)
                      .getString(context, 'cancel'),
                  color: AppColors.red,
                ))
            : SizedBox(),
        widget.confirm != null
            ? FlatButton(
                onPressed: () {
                  if (enable) {
                    widget.confirm();
                  }
                  setState(() {
                    enable = false;
                  });
                },
                child: AppText(
                  text: FlutterLocalizations.of(context)
                      .getString(context, 'confirm'),
                  color: AppColors.clickableText,
                ))
            : SizedBox()
      ],
    );
  }
}
