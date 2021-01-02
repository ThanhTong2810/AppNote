

import 'package:app_note/screen/login_screen/verify_phone_number_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

class Routes {

  static String verifyPhoneNumberScreen = '/VerifyPhoneNumberScreen';

  static final route=[
    GetPage(name: verifyPhoneNumberScreen,page: ()=>VerifyPhoneNumberScreen(),transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 500)),
  ];
}
