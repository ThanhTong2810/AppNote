class Constants {
  static const String REGEX_PHONE_NUMBER =
      '^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*\$';

  static const int MY_MAIN_SCREEN_ID = 0;
  static const int MY_DASH_BOARD_ID = 1;
  static const int MY_CATEGORY_SCREEN_ID = 2;

  ///Firestore
  static const String USER_COLLECTION = 'USERS';
  static const String CATEGORY = 'CATEGORY';
  static const String NOTES = 'NOTES';


  ///Params
  static const String PHONE_NUMBER = 'PHONE';
}
