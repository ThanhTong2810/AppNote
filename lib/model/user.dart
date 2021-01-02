class UserApp {
  String displayName;
  String phoneNumber;
  String imgURL;
  String email;
  String facebookId;
  bool isVerifyPhone;

  UserApp.fromJson(Map<dynamic, dynamic> json)
      : displayName=json['displayName']??'',
        phoneNumber = json['phoneNumber'] ?? '',
        imgURL = json['imgURL'] ?? '',
        email=json['email']??'',
        facebookId=json['facebookId']??'',
        isVerifyPhone=json['isVerifyPhone']??false;


  Map<dynamic, dynamic> toJson() => {
    'displayName': displayName??'',
    'phoneNumber': phoneNumber??'',
    'imgURL': imgURL??'',
    'email':email??'',
    'facebookId':facebookId??'',
    'isVerifyPhone':isVerifyPhone??false,
  };
}