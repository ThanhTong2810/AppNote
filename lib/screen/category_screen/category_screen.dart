import 'package:app_note/controller/category_controller.dart';
import 'package:app_note/controller/note_controller.dart';
import 'package:app_note/localization/flutter_localizations.dart';
import 'package:app_note/model/category.dart';
import 'package:app_note/theme/colors.dart';
import 'package:app_note/utils/utils.dart';
import 'package:app_note/widget/animate_menu.dart';
import 'package:app_note/widget/app_button.dart';
import 'package:app_note/widget/app_text.dart';
import 'package:app_note/widget/loading_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final Screen myCategoryScreen = Screen(
    title: 'My Category Screen',
    contentBuilder: (BuildContext context) {
      return CategoryScreen();
    });

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryController categoryController=Get.find();
  final NoteController noteController=Get.find();

  TextEditingController nameTextEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return LoadingContainer(child: Scaffold(
        body: Container(
          width: getScreenWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: StreamBuilder(
                  stream: categoryController.getAllCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData)
                      return Center(
                        child: AppText(
                          text: 'No Category',
                        ),
                      );
                    return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          Category category = snapshot.data[index];
                          return Card(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      IconButton(
                                          icon: Icon(Icons.update),
                                          onPressed: () {
                                            categoryController.isUpdate.value=true;
                                            nameTextEditingController.text=category.name;
                                            _addNoteModalBottomSheet(context,noteId: category.id);
                                          }),
                                      IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () async {
                                            await categoryController.deleteCategory(category.id);
                                            categoryController.getCategory();
                                          }),
                                    ],
                                  ),
                                  AppText(text: 'Name: ${category.name}'),
                                  AppText(
                                      text:
                                      'Created date: ${category.createdDate}'),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          child: Icon(Icons.add),
          backgroundColor: AppColors.primary,
          onPressed: () {
            categoryController.isUpdate.value=false;
            nameTextEditingController.text='';
            _addNoteModalBottomSheet(context);
          },
        ),
      ),isShowIndicator: true,isLoading: categoryController.isShowLoading.value,);
    });
  }

  void _addNoteModalBottomSheet(context,{String noteId}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return BottomSheet(
            onClosing: () {},
            builder: (BuildContext context) {
              return Obx(() {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          controller: nameTextEditingController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.add_comment_outlined),
                            hintText: 'Enter category name',
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20,top: 20),
                            child: Container(
                              child: AppButton(
                                categoryController.isUpdate.value == false
                                    ? FlutterLocalizations.of(context)
                                    .getString(context, 'confirm')
                                    : 'Edit',
                                onTap: categoryController.isUpdate.value == false
                                    ? () async {
                                  Get.back();

                                  await categoryController.addNote(nameTextEditingController.text);

                                  nameTextEditingController.text = '';
                                  List<String> category;
                                  await categoryController.getCategory();
                                  category= categoryController.listCategories.map((e) => e.name).toList();

                                  noteController.dropDownCategory = RxList<DropdownMenuItem<String>>(noteController.getDropDown(category));
                                }
                                    : () async{
                                  Get.back();
                                  categoryController.isUpdate.value = false;
                                  var data={
                                    'name': nameTextEditingController.text ?? '',
                                    'createdDate': formatDate(DateTime.now()),
                                  };
                                  await categoryController.updateCategory(noteId, data);

                                  List<String> category;
                                  await categoryController.getCategory();
                                  category= categoryController.listCategories.map((e) => e.name).toList();

                                  noteController.dropDownCategory = RxList<DropdownMenuItem<String>>(noteController.getDropDown(category));
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          );
        });
  }
}
