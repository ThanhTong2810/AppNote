import 'package:app_note/auth/auth_helper.dart';
import 'package:app_note/constants/constants.dart';
import 'package:app_note/controller/user_controller.dart';
import 'package:app_note/localization/flutter_localizations.dart';
import 'package:app_note/res/images/images.dart';
import 'package:app_note/router/routes.dart';
import 'package:app_note/screen/login_screen/collect_customer_information.dart';
import 'package:app_note/screen/login_screen/verify_phone_number_screen.dart';
import 'package:app_note/screen/main_screen/main_screen.dart';
import 'package:app_note/screen/menu_screen/menu_screen.dart';
import 'package:app_note/theme/colors.dart';
import 'package:app_note/theme/dimens.dart';
import 'package:app_note/utils/utils.dart';
import 'package:app_note/widget/app_button.dart';
import 'package:app_note/widget/app_text.dart';
import 'package:app_note/widget/backdrop_container.dart';
import 'package:app_note/widget/loading_container.dart';
import 'package:app_note/widget/slide_up_stransition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginForm extends StatefulWidget  {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>  with SingleTickerProviderStateMixin {
  
  final UserController userController=Get.find();

  TextEditingController _phoneController = TextEditingController();

  bool enable = true;

  @override
  void initState() {
    AuthHelper.onVerificationCompleted = _navigateToMainScreen;
    AuthHelper.checkErrorBlockUser = _checkErrorExceedLimitPhoneVerify;
    AuthHelper.onCodeSent = _navigateToVerifyPhoneNumber;
    AuthHelper.onNewUser = _onNavigateToCollectInformationScreen;
    AuthHelper.showAutoVerify = _showDialogAutoVerify;
    super.initState();
    userController.formController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    userController.phoneNumberExist=null;
    userController.facebookUser=null;
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SlideUpTransition(
        animationController: userController.formController,
        child: BackdropContainer(child: Obx(
              (){
            return LoadingContainer(
              isLoading: userController.isShowLoading.value,
              isShowIndicator: true,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      AppText(
                        text: FlutterLocalizations.of(context)
                            .getString(context, 'enter_your_phone_number'),
                        textSize: Dimens.paragraphHeaderTextSize,
                      ),
                      Dimens.height30,
                      Container(
                        height: getScreenHeight(context) / 15,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(Images.vn_flag),
                            ),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    hintText: FlutterLocalizations.of(context)
                                        .getString(context, 'phone_number'),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10)),
                                controller: _phoneController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppText(
                        text: userController.msgError.value,
                        color: AppColors.red,
                      ),
                      Dimens.height20,
                      AppButton(
                          FlutterLocalizations.of(context)
                              .getString(context, 'sign_in'), onTap: () async {
                        await _loginByPhoneNumber(_phoneController.text.trim());
                      }),
                      Dimens.height20,
                      Align(
                        alignment: Alignment.center,
                        child: AppText(
                          text: 'OR',
                          color: AppColors.paragraphText,
                        ),
                      ),
                      Dimens.height20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: AppColors.white,
                              radius: 30.0,
                              backgroundImage:
                              NetworkImage('https://images.theconversation.com/files/93616/original/image-20150902-6700-t2axrz.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1000&fit=clip'),
                            ),
                            onTap: () {
                              userController.signInWithGoogle();
                            },
                          ),
                          Dimens.width30,
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: AppColors.white,
                              radius: 30.0,
                              backgroundImage:
                              NetworkImage('https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png'),
                            ),
                            onTap: () {
                              userController.signInWithFaceBook();
                            },
                          ),
                        ],
                      ),
                      Dimens.quarterHeight(context)
                    ],
                  ),
                ),
              ),
            );
          },
        ),),
      ),
    );
  }

  _checkErrorExceedLimitPhoneVerify(String error) {
    userController.isShowLoading.value = false;

    if (error.contains('interrupted connection')) {
      userController.msgError.value = FlutterLocalizations.of(context)
          .getString(context, 'no_connection');
    } else if (error.contains('blocked')) {
      userController.msgError.value = FlutterLocalizations.of(context)
          .getString(context, 'block_phoneNumber');
    } else if (error.contains('TOO_LONG')) {
      userController.msgError.value = FlutterLocalizations.of(context)
          .getString(context, 'incorret_phoneInput_long');
    } else if (error.contains('TOO_SHORT')) {
      userController.msgError.value = FlutterLocalizations.of(context)
          .getString(context, 'incorret_phoneInput_short');
    }
  }

  _showDialogAutoVerify() {
    userController.isShowLoading.value = false;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(FlutterLocalizations.of(context)
              .getString(context, 'auto_verify')),
          content: Text(FlutterLocalizations.of(context)
              .getString(context, 'auto_verify_content')),
        );
      },
    );
  }

  _navigateToMainScreen(uid) async {
    await userController.loadUserData(uid);
    userController.formController.reverse();
    Get.offAll(MenuMainScreen());
  }

  _onNavigateToCollectInformationScreen(data) {
    hideKeyboard(context);
    userController.msgError.value = '';

    userController.firebaseUser = data.user;
    Get.offAll(CollectCustomerInformationScreen(isVerifyPhone: true));
  }

  _navigateToVerifyPhoneNumber() async {
    Get.to(VerifyPhoneNumberScreen(),arguments: '${Routes.verifyPhoneNumberScreen}'
        '?${Constants.PHONE_NUMBER}=${addCountryCode(_phoneController.text.trim())}');
  }

  bool _validate() {
    String phoneNumber = (_phoneController.text.trim());
    RegExp regExp = RegExp(Constants.REGEX_PHONE_NUMBER);
    if (phoneNumber.isEmpty) {

      userController.msgError.value = "Please input your phone number";

      return false;
    } else if (!regExp.hasMatch(phoneNumber)) {

      userController.msgError.value = "Invalid phone number";

      return false;
    } else {
      userController.msgError.value = '';

      return true;
    }
  }

  _loginByPhoneNumber(String phoneNumber) async {
    hideKeyboard(context);
    if (_validate()) {
      userController.loginWithPhoneNumber(addCountryCode(phoneNumber));
    }
  }
}
