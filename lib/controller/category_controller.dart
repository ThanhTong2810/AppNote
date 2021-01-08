import 'package:app_note/constants/constants.dart';
import 'package:app_note/helper/firebase_helper.dart';
import 'package:app_note/model/category.dart';
import 'package:app_note/model/user.dart';
import 'package:app_note/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController{
  RxList<Category> listCategories= RxList<Category>([]);
  Rx<bool> isShowLoading = Rx<bool>(false);
  Rx<bool> isUpdate = Rx<bool>(false);

  Stream<List<Category>> getAllCategories() {
    return FirebaseHelper.fireStoreReference
        .collection(Constants.CATEGORY)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList());
  }

  addNote(String name) async {
    isShowLoading.value = true;
    String categoryId;
    var categoryData = {
      'name': name ?? '',
      'createdDate': formatDate(DateTime.now()),
    };
    await FirebaseHelper.fireStoreReference
        .collection(Constants.CATEGORY)
        .add(categoryData)
        .then((value) => categoryId = value.id);
    await FirebaseHelper.fireStoreReference
        .collection(Constants.CATEGORY)
        .doc(categoryId)
        .update({'id': categoryId.trim()});
    listCategories.add(Category.fromJson(categoryData));
    isShowLoading.value = false;
  }

  updateCategory(String id,Map<String, dynamic>data) async{
    isShowLoading.value = true;
    await FirebaseHelper.fireStoreReference
        .collection(Constants.CATEGORY)
        .doc(id).update(data);
    isShowLoading.value = false;
  }

  deleteCategory(String id) async {
    isShowLoading.value = true;
    await FirebaseHelper.fireStoreReference
        .collection(Constants.CATEGORY)
        .doc(id)
        .delete();
    isShowLoading.value = false;
  }

  getCategory() async{
    QuerySnapshot snapshot=await FirebaseHelper.fireStoreReference
        .collection(Constants.CATEGORY)
        .get();
    listCategories=RxList<Category>(snapshot.docs.map((e) => Category.fromJson(e.data())).toList());
  }
}