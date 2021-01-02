

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelper{
  static final  fireBaseAuth = FirebaseAuth.instance;
  static final fireStoreReference = FirebaseFirestore.instance;
  static final fireBaseStorage = FirebaseStorage.instance;
  static StorageUploadTask uploadTask;
  static StorageTaskSnapshot storageTaskSnapshot;
}