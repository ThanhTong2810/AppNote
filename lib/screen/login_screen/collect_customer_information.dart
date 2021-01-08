import 'package:app_note/controller/user_controller.dart';
import 'package:app_note/localization/flutter_localizations.dart';
import 'package:app_note/screen/menu_screen/menu_screen.dart';
import 'package:app_note/theme/colors.dart';
import 'package:app_note/theme/dimens.dart';
import 'package:app_note/utils/utils.dart';
import 'package:app_note/widget/app_button.dart';
import 'package:app_note/widget/app_text.dart';
import 'package:app_note/widget/backdrop_container.dart';
import 'package:app_note/widget/fade_container.dart';
import 'package:app_note/widget/gradient_background.dart';
import 'package:app_note/widget/loading_container.dart';
import 'package:app_note/widget/slide_up_stransition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CollectCustomerInformationScreen extends StatefulWidget {
  final phoneNumber;
  final bool isVerifyPhone;

  const CollectCustomerInformationScreen({Key key, this.phoneNumber, this.isVerifyPhone}) : super(key: key);

  @override
  _CollectCustomerInformationScreenState createState() =>
      _CollectCustomerInformationScreenState();
}

class _CollectCustomerInformationScreenState
    extends State<CollectCustomerInformationScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  TextEditingController nameController;

  final UserController userController=Get.find();

  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  ///           OVERRIDE METHODS           ///
  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  @override
  void initState() {
    super.initState();
    onWidgetBuildDone(onBuildDone);
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initUserStore();
    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: Obx(
        (){
          return LoadingContainer(
            isLoading: userController.isShowLoading.value,
            child: GradientBackground(
                child: Column(
                  children: <Widget>[
                    _buildHeader(),
                    Expanded(
                      child: SlideUpTransition(
                        animationController: controller,
                        child: BackdropContainer(
                          child: Center(
                            child: SingleChildScrollView(child: _buildBody()),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          );
        },
      ),
    );
  }

  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  ///           BUILD METHODS              ///
  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Dimens.height30,
            FadeContainer(
              child: AppText(
                text: FlutterLocalizations.of(context)
                    .getString(context, 'complete_your_profile'),
                textSize: Dimens.headerTextSize,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Obx((){
      return Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              hintText:
              FlutterLocalizations.of(context).getString(context, 'name'),
            ),
            controller: nameController,
            textCapitalization: TextCapitalization.words,
          ),
          Dimens.height10,
          AppText(
            text: userController.errorMsg.value,
            color: AppColors.red,
            textSize: Dimens.errorTextSize,
          ),
          Dimens.height10,
          AppButton(
            FlutterLocalizations.of(context).getString(context, 'confirm'),
            onTap: () {
              hideKeyboard(context);
              _createNewUser();
            },
          ),
          Dimens.quarterHeight(context),
        ],
      );
    });
  }

  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  ///             OTHER METHODS            ///
  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///090
  onBuildDone() async {}

  _initUserStore() {
    userController.onCreateUserSuccess = _onCreateUserSuccess;
  }

  _createNewUser() async {
    if (nameController.text.isEmpty) {
        userController.errorMsg.value = FlutterLocalizations.of(context)
            .getString(context, 'please_input_your_name');
        userController.nameValid.value = false;
    } else {
      userController.errorMsg.value = '';
      userController.nameValid.value = true;
    }

    if (userController.nameValid.value) {
      userController.errorMsg.value = '';

      showConfirmDialog(context,
          title: 'Xác nhận',
          content: 'Xác nhận hoàn tất hồ sơ của bạn',
          cancel: () => Navigator.pop(context),
          confirm: () async {
            await userController.createNewUser(
                displayName: nameController.text ?? '',
                // ignore: deprecated_member_use
                phoneNumber: userController.firebaseUser.isNullOrBlank?addCountryCode(widget.phoneNumber):userController.firebaseUser.phoneNumber.trim(),
                isVerifyPhone: widget.isVerifyPhone);
          });
      }
    }

  _onCreateUserSuccess() {
    hideKeyboard(context);
    Get.offAll(MenuMainScreen());
  }
}
