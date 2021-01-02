import 'package:app_note/controller/user_controller.dart';
import 'package:app_note/localization/flutter_localizations.dart';
import 'package:app_note/theme/colors.dart';
import 'package:app_note/theme/dimens.dart';
import 'package:app_note/utils/utils.dart';
import 'package:app_note/widget/animate_menu.dart';
import 'package:app_note/widget/app_button.dart';
import 'package:app_note/widget/app_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Settings',
          color: AppColors.white,
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: <Widget>[
            _buildHeader(context),
            _buildAppInformation(),
            Card(
              color: AppColors.red,
              child: FlatButton(
                  onPressed: () {
                    showConfirmDialog(context,
                        title: FlutterLocalizations.of(context)
                            .getString(context, 'confirm'),
                        content: FlutterLocalizations.of(context)
                            .getString(context, 'log_out_dialog'),
                        cancel: () => Navigator.pop(context),
                        confirm: () async {
                          await userController.logout();
                        });
                  },
                  child: AppText(
                    text: FlutterLocalizations.of(context)
                        .getString(context, 'log_out'),
                    color: AppColors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Obx(() {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Material(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          elevation: 5.0,
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        onTap: _changeAvatar,
                        child: Material(
                            elevation: 5.0,
                            shape: CircleBorder(
                                side: BorderSide(color: AppColors.white)),
                            child: userController.user != null
                                ? (userController.user.value.imgURL != null &&
                                userController.user.value.imgURL.isNotEmpty)
                                ? ClipOval(
                              child: CachedNetworkImage(
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(
                                        strokeWidth: 80,
                                      ),
                                  imageUrl:
                                  userController.user.value.imgURL),
                            )
                                : Icon(Icons.person)
                                : Icon(Icons.person))),
                  ],
                ),
                Dimens.height30,
                AppText(
                  text: userController.user != null
                      ? userController.user.value.displayName
                      : '',
                  textSize: Dimens.paragraphHeaderTextSize,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAppInformation() {
    return Material(
      child: Column(
        children: <Widget>[
         
        ],
      ),
    );
  }

  void _changeAvatar() {
    if (userController.user != null) {
      showCupertinoModalPopup(
          context: context,
          builder: (context) => _buildCupertinoActionSheetChangeAvatar());
    }
  }

  Widget _buildCupertinoActionSheetChangeAvatar() {
    return CupertinoActionSheet(
      message: AppText(
          text: FlutterLocalizations.of(context)
              .getString(context, 'change_avatar')),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: AppText(
            text: FlutterLocalizations.of(context)
                .getString(context, 'choose_from_library'),
            color: AppColors.clickableText,
          ),
          onPressed: () async {
            userController.choosePhotoFromLibrary();
            Get.back();
          },
        ),
        CupertinoActionSheetAction(
          child: AppText(
            text: FlutterLocalizations.of(context)
                .getString(context, 'take_new_picture'),
            color: AppColors.clickableText,
          ),
          onPressed: () async {
            userController.takeNewPhoto();
            Get.back();
          },
        ),
      ],
    );
  }
}
