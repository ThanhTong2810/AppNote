class UserApp {
  String displayName;
  String phoneNumber;
  String imgURL;
  String email;
  String facebookId;

  UserApp.fromJson(Map<dynamic, dynamic> json)
      : displayName=json['displayName']??'',
        phoneNumber = json['phoneNumber'] ?? '',
        imgURL = json['imgURL'] ?? '',
        email=json['email']??'',
        facebookId=json['facebookId']??'';


  Map<dynamic, dynamic> toJson() => {
    'displayName': displayName??'',
    'phoneNumber': phoneNumber??'',
    'imgURL': imgURL??'',
    'email':email??'',
    'facebookId':facebookId??'',
  };
}