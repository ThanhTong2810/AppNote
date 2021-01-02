
import 'package:app_note/controller/user_controller.dart';
import 'package:app_note/localization/flutter_localizations.dart';
import 'package:app_note/screen/login_screen/collect_customer_information.dart';
import 'package:app_note/screen/main_screen/main_screen.dart';
import 'package:app_note/screen/menu_screen/menu_screen.dart';
import 'package:app_note/theme/colors.dart';
import 'package:app_note/theme/dimens.dart';
import 'package:app_note/utils/utils.dart';
import 'package:app_note/widget/app_text.dart';
import 'package:app_note/widget/backdrop_container.dart';
import 'package:app_note/widget/fade_container.dart';
import 'package:app_note/widget/gradient_background.dart';
import 'package:app_note/widget/loading_container.dart';
import 'package:app_note/widget/slide_up_stransition.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {

  @override
  _VerifyPhoneNumberScreenState createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen>
    with SingleTickerProviderStateMixin {
  final UserController _userController=Get.find();

  AnimationController _verifyPhoneController;
  FocusNode focusNode;
  TextEditingController controller;

  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  ///           OVERRIDE METHODS           ///
  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  @override
  void initState() {
    focusNode = FocusNode();
    controller = TextEditingController();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        controller.clear();
      }
    });
    super.initState();
    _verifyPhoneController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _userController?.timer?.cancel();
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
            isLoading: _userController.isShowLoading.value,
            child: GradientBackground(
                child: Column(
                  children: <Widget>[
                    _buildHeader(),
                    Expanded(
                      child: SlideUpTransition(
                        animationController: _verifyPhoneController,
                        child: BackdropContainer(
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[_buildBody()],
                                  ),
                                ),
                              ),
                            ],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Dimens.height30,
          FadeContainer(
            child: AppText(
              text: FlutterLocalizations.of(context)
                  .getString(context, 'verify_your_phone_number'),
              textSize: Dimens.headerTextSize,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: 20.0),
            Expanded(
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: FlutterLocalizations.of(context)
                        .getString(context, 'please_enter_the'),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400)),
                TextSpan(
                    text: FlutterLocalizations.of(context)
                        .getString(context, 'otp'),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700)),
                TextSpan(
                    text: FlutterLocalizations.of(context)
                        .getString(context, 'sent_to_your_mobile'),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400)),
              ])),
            ),
            SizedBox(width: 20.0),
          ],
        ),
        SizedBox(height: 15.0),
        TextField(
          autofocus: true,
          maxLength: 6,
          focusNode: focusNode,
          controller: controller,
          decoration: InputDecoration(
              hintText:
                  FlutterLocalizations.of(context).getString(context, 'otp')),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.numberWithOptions(),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (String value) {
            if (value.length == 6) {
              _verifyPhoneNumber(value);
            }
          },
        ),
        Dimens.height10,
        RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: FlutterLocalizations.of(context)
                      .getString(context, 'otp_will_expire'),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400)),
              TextSpan(
                  text: _userController.start.toString(),
                  style:
                  TextStyle(color: Colors.red, fontWeight: FontWeight.w400)),
              TextSpan(
                  text: FlutterLocalizations.of(context)
                      .getString(context, 'seconds'),
                  style:
                  TextStyle(color: Colors.red, fontWeight: FontWeight.w400)),
              TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (_userController.start.value == 0) {
                        _userController.resendOTP(Get.arguments);
                        _userController.start.value =100;
                        _userController.startTimer();
                      } else {}
                    },
                  text: FlutterLocalizations.of(context)
                      .getString(context, 'resend_otp'),
                  style: TextStyle(
                      color: _userController.start.value == 0 ? Colors.black : Colors.grey,
                      fontWeight: FontWeight.bold)),
            ])),
        Dimens.height10,
        Obx((){
          return AppText(
            text: _userController.msgError.value,
            color: AppColors.red,
            textSize: Dimens.errorTextSize,
          );
        })
      ],
    );
  }

  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  ///             OTHER METHODS            ///
  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///

  _initUserStore() {
    _userController.onAuthSuccess = _onLoginSuccess;
    _userController.onSMSOTPExpired = _onSMSOTPExpired;
    _userController.onWrongSMSOTP = _onWrongSMSOTP;
    _userController.onNavigateToCollectInformationScreen =
        _onNavigateToCollectInformationScreen;
    _userController.start.value = 100;
    _userController.startTimer();
  }

  _onLoginSuccess() {
    _userController.updateVerifyPhoneTrue(_userController.user.value.phoneNumber);
    _userController.timer.cancel();
    hideKeyboard(context);
    _userController.msgError.value = "";
    Get.to(MenuMainScreen());
  }

  _onNavigateToCollectInformationScreen() {
    _userController.timer.cancel();
    hideKeyboard(context);
    _userController.msgError.value = "";
    Get.to(CollectCustomerInformationScreen(isVerifyPhone: true,));
  }

  _onSMSOTPExpired() {
    _userController.msgError.value =
        FlutterLocalizations.of(context).getString(context, 'expire_otp');
  }

  _onWrongSMSOTP() {
    _userController.msgError.value =
        FlutterLocalizations.of(context).getString(context, 'invalid_otp');
  }

  onEmptyOtpMessage() {
    _userController.msgError.value =
        FlutterLocalizations.of(context).getString(context, 'empty_otp');
  }

  _verifyPhoneNumber(String smsOTP) {
    hideKeyboard(context);
    _userController.verifyPhoneNumber(smsOTP);
  }
}
