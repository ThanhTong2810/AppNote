import 'package:app_note/constants/constants.dart';
import 'package:app_note/helper/firebase_helper.dart';
import 'package:app_note/model/note.dart';
import 'package:app_note/model/user.dart';
import 'package:app_note/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class NoteController extends GetxController{
  Rx<String> currentCategory=Rx<String>('');
  Rx<String> currentPriority=Rx<String>('');
  Rx<String> currentStatus=Rx<String>('');

  Rx<DateTime> pickedDate=Rx<DateTime>();

  Rx<bool> isShowLoading=Rx<bool>(false);
  Rx<bool> isUpdate=Rx<bool>(false);

  RxList<Note> listNotes=RxList<Note>([]);

  getAllNotes(UserApp user) async{
    isShowLoading.value=true;
    QuerySnapshot snapshot=await FirebaseHelper.fireStoreReference.collection(Constants.USER_COLLECTION).doc(user.phoneNumber).collection(Constants.NOTES).get();
    for(var notes in snapshot.docs){
      var note=Note.fromJson(notes.data());
      listNotes.add(note);
    }
    isShowLoading.value=false;
  }

  addNote(String name, String category, String priority, String status, DateTime planDate,UserApp user) async{
    isShowLoading.value=true;
    String noteId;
    var noteData={
      'name':name??'',
      'category':category,
      'priority':priority,
      'status':status,
      'planDate':formatDate(planDate),
      'createdDate':formatDate(DateTime.now()),
    };
    await FirebaseHelper.fireStoreReference.collection(Constants.USER_COLLECTION).doc(user.phoneNumber).collection(Constants.NOTES).add(noteData).then((value) => noteId=value.id);
    await FirebaseHelper.fireStoreReference.collection(Constants.USER_COLLECTION).doc(user.phoneNumber).collection(Constants.NOTES).doc(noteId).update({'id': noteId.trim()});
    isShowLoading.value=false;
  }

  deleteNote(UserApp user,String id) async{
    await FirebaseHelper.fireStoreReference.collection(Constants.USER_COLLECTION).doc(user.phoneNumber).collection(Constants.NOTES).doc(id).delete();
  }
}