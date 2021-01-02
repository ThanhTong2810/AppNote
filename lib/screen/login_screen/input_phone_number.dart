import 'package:app_note/constants/constants.dart';
import 'package:app_note/controller/user_controller.dart';
import 'package:app_note/helper/firebase_helper.dart';
import 'package:app_note/localization/flutter_localizations.dart';
import 'package:app_note/screen/login_screen/collect_customer_information.dart';
import 'package:app_note/theme/colors.dart';
import 'package:app_note/theme/dimens.dart';
import 'package:app_note/utils/utils.dart';
import 'package:app_note/widget/app_button.dart';
import 'package:app_note/widget/app_text.dart';
import 'package:app_note/widget/backdrop_container.dart';
import 'package:app_note/widget/fade_container.dart';
import 'package:app_note/widget/gradient_background.dart';
import 'package:app_note/widget/slide_up_stransition.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputPhoneNumber extends StatefulWidget {
  @override
  _InputPhoneNumberState createState() => _InputPhoneNumberState();
}

class _InputPhoneNumberState extends State<InputPhoneNumber>
    with SingleTickerProviderStateMixin {
  final UserController userController = Get.find();
  AnimationController controller;
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
    onWidgetBuildDone((){
      userController.msgError.value='';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        ),
      ),
    );
  }

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
                    .getString(context, 'enter_your_phone_number'),
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
    return Obx(() {
      return Column(
        children: <Widget>[
          TextField(
            autofocus: true,
            decoration: InputDecoration(
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              hintText: FlutterLocalizations.of(context)
                  .getString(context, 'phone_number'),
            ),
            controller: phoneController,
            textCapitalization: TextCapitalization.words,
          ),
          Dimens.height10,
          AppText(
            text: userController.msgError.value,
            color: AppColors.red,
          ),
          Dimens.height10,
          AppButton(
            FlutterLocalizations.of(context).getString(context, 'confirm'),
            onTap: () {
              hideKeyboard(context);
              checkPhoneNumberExistOrNot(phoneController.text.trim());
            },
          ),
          Dimens.quarterHeight(context),
        ],
      );
    });
  }

  bool validate() {
    String phoneNumber = (phoneController.text.trim());
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

  checkPhoneNumberExistOrNot(String phoneNumber) {
    hideKeyboard(context);
    if (validate()) {
      FirebaseHelper.fireStoreReference
          .collection(Constants.USER_COLLECTION)
          .doc(addCountryCode(phoneNumber))
          .get()
          .then((doc) async{
        if(doc.exists){
          userController.msgError.value='Your phone number already exist';
          return false;
        }
        else{
          Get.to(CollectCustomerInformationScreen(phoneNumber: phoneController.text.trim(),isVerifyPhone: false));
        }
      });
    }
  }
}
