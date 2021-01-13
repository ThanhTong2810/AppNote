import 'package:app_note/constants/constants.dart';
import 'package:app_note/helper/firebase_helper.dart';
import 'package:app_note/helper/notification_helper.dart';
import 'package:app_note/model/note.dart';
import 'package:app_note/model/user.dart';
import 'package:app_note/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoteController extends GetxController {
  Rx<String> currentCategory = Rx<String>('');
  Rx<String> currentPriority = Rx<String>('');
  Rx<String> currentStatus = Rx<String>('');

  Rx<String> msgErr=Rx<String>('');

  RxList<DropdownMenuItem<String>> dropDownCategory=RxList<DropdownMenuItem<String>>([]);
  RxList<DropdownMenuItem<String>> dropDownPriority=RxList<DropdownMenuItem<String>>([]);
  RxList<DropdownMenuItem<String>> dropDownStatus=RxList<DropdownMenuItem<String>>([]);

  Rx<DateTime> pickedDate = Rx<DateTime>();

  Rx<bool> isShowLoading = Rx<bool>(false);
  Rx<bool> isUpdate = Rx<bool>(false);

  RxList<Note> listNotes = RxList<Note>([]);
  Rx<int> doneLength=Rx<int>(0);
  Rx<int> pendingLength=Rx<int>(0);
  Rx<int> processingLength=Rx<int>(0);

  List<DropdownMenuItem<String>> getDropDown(List<String> list) {
    List<DropdownMenuItem<String>> items = new List();
    for (String item in list) {
      items.add(new DropdownMenuItem(value: item, child: new Text(item)));
    }
    return items;
  }

  Stream<List<Note>> getAllNotes(UserApp user) {
    return FirebaseHelper.fireStoreReference
        .collection(Constants.USER_COLLECTION)
        .doc(user.phoneNumber)
        .collection(Constants.NOTES)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList());
  }

  addNote(String name, String category, String priority, String status,
      DateTime planDate, UserApp user) async {
    isShowLoading.value = true;
    String noteId;
    var noteData = {
      'name': name ?? '',
      'category': category,
      'priority': priority,
      'status': status,
      'planDate': formatDate(planDate),
      'createdDate': formatDate(DateTime.now()),
    };
    await FirebaseHelper.fireStoreReference
        .collection(Constants.USER_COLLECTION)
        .doc(user.phoneNumber)
        .collection(Constants.NOTES)
        .add(noteData)
        .then((value) => noteId = value.id);
    await FirebaseHelper.fireStoreReference
        .collection(Constants.USER_COLLECTION)
        .doc(user.phoneNumber)
        .collection(Constants.NOTES)
        .doc(noteId)
        .update({'id': noteId.trim()});
    listNotes.add(Note.fromJson(noteData));
    NotificationHelper.scheduleAlarm(planDate,noteId.hashCode, '$name');

    isShowLoading.value = false;
  }

  updateNote(UserApp user, String id,Map<String, dynamic>data) async{
    isShowLoading.value = true;
    await FirebaseHelper.fireStoreReference
        .collection(Constants.USER_COLLECTION)
        .doc(user.phoneNumber)
        .collection(Constants.NOTES)
        .doc(id).update(data);
    isShowLoading.value = false;
  }

  deleteNote(UserApp user, String id) async {
    isShowLoading.value = true;
    await FirebaseHelper.fireStoreReference
        .collection(Constants.USER_COLLECTION)
        .doc(user.phoneNumber)
        .collection(Constants.NOTES)
        .doc(id)
        .delete();
    isShowLoading.value = false;
  }

  getNote(UserApp user) async{
    QuerySnapshot snapshot=await FirebaseHelper.fireStoreReference
        .collection(Constants.USER_COLLECTION)
        .doc(user.phoneNumber)
        .collection(Constants.NOTES).get();
    listNotes=RxList<Note>(snapshot.docs.map((e) => Note.fromJson(e.data())).toList());
    doneLength.value=listNotes.where((e) => e.status=='Done').toList().length;
    pendingLength.value=listNotes.where((e) => e.status=='Pending').toList().length;
    processingLength.value=listNotes.where((e) => e.status=='Processing').toList().length;
  }
}
