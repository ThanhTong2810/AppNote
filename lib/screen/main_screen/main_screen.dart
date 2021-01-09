import 'package:app_note/auth/auth_helper.dart';
import 'package:app_note/constants/constants.dart';
import 'package:app_note/controller/category_controller.dart';
import 'package:app_note/controller/note_controller.dart';
import 'package:app_note/controller/user_controller.dart';
import 'package:app_note/localization/flutter_localizations.dart';
import 'package:app_note/model/note.dart';
import 'package:app_note/router/routes.dart';
import 'package:app_note/screen/login_screen/collect_customer_information.dart';
import 'package:app_note/screen/menu_screen/menu_screen.dart';
import 'package:app_note/theme/colors.dart';
import 'package:app_note/utils/utils.dart';
import 'package:app_note/widget/animate_menu.dart';
import 'package:app_note/widget/app_button.dart';
import 'package:app_note/widget/app_text.dart';
import 'package:app_note/widget/loading_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final Screen myMainScreen = Screen(
    title: 'My Main Screen',
    contentBuilder: (BuildContext context) {
      return MainScreen();
    });

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final UserController userController = Get.find();
  final NoteController noteController = Get.find();
  final CategoryController categoryController = Get.find();

  int length = 0;

  TextEditingController nameTextEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return LoadingContainer(
        child: Scaffold(
          body: Container(
            width: getScreenWidth(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: StreamBuilder(
                    stream:
                        noteController.getAllNotes(userController.user.value),
                    builder: (context, snapshot) {
                      if (snapshot.hasError || !snapshot.hasData)
                        return Center(
                          child: AppText(
                            text: 'No Note',
                          ),
                        );
                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            Note note = snapshot.data[index];
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
                                              noteController.isUpdate.value =
                                                  true;
                                              nameTextEditingController.text =
                                                  note.name;
                                              noteController.currentCategory
                                                  .value = note.category;
                                              noteController.currentPriority
                                                  .value = note.priority;
                                              noteController.currentStatus
                                                  .value = note.status;
                                              _addNoteModalBottomSheet(context,
                                                  noteId: note.id);
                                            }),
                                        IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () async {
                                              await noteController.deleteNote(
                                                  userController.user.value,
                                                  note.id);
                                              noteController.getNote(
                                                  userController.user.value);
                                            })
                                      ],
                                    ),
                                    AppText(text: 'Name: ${note.name}'),
                                    AppText(text: 'Category: ${note.category}'),
                                    AppText(text: 'Priority: ${note.priority}'),
                                    AppText(text: 'Status: ${note.status}'),
                                    AppText(
                                        text: 'Plan date: ${note.planDate}'),
                                    AppText(
                                        text:
                                            'Created date: ${note.createdDate}'),
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
              noteController.isUpdate.value = false;
              nameTextEditingController.text = '';
              nameTextEditingController.text = '';
              noteController.currentCategory.value =
                  noteController.dropDownCategory[0].value;
              noteController.currentPriority.value =
                  noteController.dropDownPriority[0].value;
              noteController.currentStatus.value =
                  noteController.dropDownStatus[0].value;
              noteController.pickedDate.value = null;
              _addNoteModalBottomSheet(context);
            },
          ),
        ),
        isLoading: noteController.isShowLoading.value,
        isShowIndicator: true,
      );
    });
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 50),
      lastDate: DateTime(DateTime.now().year + 50),
      context: context,
    );
    if (date != null) {
      noteController.pickedDate.value = date;
    }
  }

  void _addNoteModalBottomSheet(context, {String noteId}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Obx(() {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: nameTextEditingController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.add_comment_outlined),
                          hintText: 'Enter note name',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: AppText(
                          text: noteController.msgErr.value,
                          color: AppColors.red,
                        ),
                      ),
                      ListTile(
                        leading: AppText(text: 'Category'),
                        trailing: DropdownButton(
                          hint: AppText(text: 'Select category'),
                          value: noteController.currentCategory.value,
                          items: noteController.dropDownCategory,
                          onChanged: (selectedCategory) {
                            noteController.currentCategory.value =
                                selectedCategory.toString();
                          },
                        ),
                      ),
                      ListTile(
                        leading: AppText(text: 'Priority'),
                        trailing: DropdownButton(
                          hint: AppText(text: 'Select priority'),
                          value: noteController.currentPriority.value,
                          items: noteController.dropDownPriority,
                          onChanged: (selectedPriority) {
                            noteController.currentPriority.value =
                                selectedPriority.toString();
                          },
                        ),
                      ),
                      ListTile(
                        leading: AppText(text: 'Status'),
                        trailing: DropdownButton(
                          hint: AppText(text: 'Select status'),
                          value: noteController.currentStatus.value,
                          items: noteController.dropDownStatus,
                          onChanged: (selectedStatus) {
                            noteController.currentStatus.value =
                                selectedStatus.toString();
                          },
                        ),
                      ),
                      ListTile(
                        leading: AppText(
                          text: 'Plan date',
                        ),
                        trailing: GestureDetector(
                          child: noteController.pickedDate.value != null
                              ? AppText(
                                  text:
                                      '${formatDate(noteController.pickedDate.value)}')
                              : Icon(Icons.date_range_sharp),
                          onTap: () {
                            _pickDate();
                          },
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Container(
                            child: AppButton(
                              noteController.isUpdate.value == false
                                  ? FlutterLocalizations.of(context)
                                      .getString(context, 'confirm')
                                  : 'Edit',
                              onTap: noteController.isUpdate.value == false
                                  ? () async {
                                      if (nameTextEditingController
                                          // ignore: deprecated_member_use
                                          .text.isNullOrBlank)
                                        return noteController.msgErr.value =
                                            'Please Enter Your Name Note';
                                      if (noteController
                                          // ignore: deprecated_member_use
                                          .pickedDate.value.isNullOrBlank)
                                        return noteController.msgErr.value =
                                            'Please choose a date';
                                      else {
                                        Get.back();
                                        noteController.msgErr.value = '';
                                        await noteController.addNote(
                                            nameTextEditingController.text,
                                            noteController
                                                .currentCategory.value,
                                            noteController
                                                .currentPriority.value,
                                            noteController.currentStatus.value,
                                            noteController.pickedDate.value,
                                            userController.user.value);

                                        noteController
                                            .getNote(userController.user.value);

                                        nameTextEditingController.text = '';
                                        noteController.currentCategory.value =
                                            noteController
                                                .dropDownCategory[0].value;
                                        noteController.currentPriority.value =
                                            noteController
                                                .dropDownPriority[0].value;
                                        noteController.currentStatus.value =
                                            noteController
                                                .dropDownStatus[0].value;
                                        noteController.pickedDate.value = null;
                                      }
                                    }
                                  : () async {
                                      if (noteController
                                          // ignore: deprecated_member_use
                                          .pickedDate.value.isNullOrBlank)
                                        return noteController.msgErr.value =
                                            'Please choose a date';
                                      else {
                                        Get.back();
                                        noteController.msgErr.value = '';
                                        noteController.isUpdate.value = false;
                                        var data = {
                                          'name':
                                              nameTextEditingController.text ??
                                                  '',
                                          'category': noteController
                                              .currentCategory.value,
                                          'priority': noteController
                                              .currentPriority.value,
                                          'status': noteController
                                              .currentStatus.value,
                                          'planDate': formatDate(
                                              noteController.pickedDate.value),
                                          'createdDate':
                                              formatDate(DateTime.now()),
                                        };
                                        await noteController.updateNote(
                                            userController.user.value,
                                            noteId,
                                            data);

                                        noteController
                                            .getNote(userController.user.value);
                                      }
                                    },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}
