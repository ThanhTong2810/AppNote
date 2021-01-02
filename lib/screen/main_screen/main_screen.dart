import 'package:app_note/auth/auth_helper.dart';
import 'package:app_note/constants/constants.dart';
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
  TextEditingController nameTextEditingController = new TextEditingController();
  List<String> category = ['Working', 'Study', 'Relax'];
  List<String> priority = ['Slow', 'Medium', 'High'];
  List<String> status = ['Processing', 'Done', 'Pending'];

  List<DropdownMenuItem<String>> _dropDownCategory;
  List<DropdownMenuItem<String>> _dropDownPriority;
  List<DropdownMenuItem<String>> _dropDownStatus;

  List<DropdownMenuItem<String>> getDropDown(List<String> list) {
    List<DropdownMenuItem<String>> items = new List();
    for (String item in list) {
      items.add(new DropdownMenuItem(value: item, child: new Text(item)));
    }
    return items;
  }

  @override
  void initState() {
    AuthHelper.onVerificationCompleted = _navigateToMainScreen;
    AuthHelper.checkErrorBlockUser = _checkErrorExceedLimitPhoneVerify;
    AuthHelper.onCodeSent = _navigateToVerifyPhoneNumber;
    AuthHelper.onNewUser = _onNavigateToCollectInformationScreen;
    AuthHelper.showAutoVerify = _showDialogAutoVerify;
    super.initState();

    noteController.getAllNotes(userController.user.value);

    _dropDownCategory = getDropDown(category);
    _dropDownPriority = getDropDown(priority);
    _dropDownStatus = getDropDown(status);


    noteController.currentCategory.value=_dropDownCategory[0].value;
    noteController.currentPriority.value=_dropDownPriority[0].value;
    noteController.currentStatus.value=_dropDownStatus[0].value;
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
                _buildCardVerifyPhone(),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: noteController.listNotes.map((note){
                      return Card(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AppText(text: 'Name: ${note.name}'),
                              AppText(text: 'Category: ${note.category}'),
                              AppText(text: 'Priority: ${note.priority}'),
                              AppText(text: 'Status: ${note.status}'),
                              AppText(text: 'Plan date: ${note.planDate}'),
                              AppText(text: 'Created date: ${note.createdDate}'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(icon: Icon(Icons.update), onPressed: (){
                                    noteController.isUpdate.value=true;
                                    _addNoteModalBottomSheet(context);
                                  }),
                                  IconButton(icon: Icon(Icons.delete), onPressed: () async{
                                    await noteController.deleteNote(userController.user.value, note.id);
                                    noteController.listNotes.removeAt(noteController.listNotes.indexOf(note));
                                  })
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: AppColors.primary,
            onPressed: () {
              _addNoteModalBottomSheet(context);
            },
          ),
        ),
        isLoading: noteController.isShowLoading.value,
        isShowIndicator: true,
      );
    });
  }

  Widget _buildCardVerifyPhone() {
    return userController.user.value != null
        ? userController.user.value.isVerifyPhone == false ||
                userController.user.value.isVerifyPhone.isNullOrBlank
            ? Card(
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: AppColors.primary)),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    children: <Widget>[
                      AppText(
                          text: FlutterLocalizations.of(context)
                              .getString(context, "verify_your_phone_number")),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: AppButton(
                          FlutterLocalizations.of(context)
                              .getString(context, 'continue'),
                          onTap: () {
                            AuthHelper.verifyPhoneNumber(
                                userController.user.value.phoneNumber);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container()
        : Container();
  }

  _navigateToMainScreen(uid) async {
    await userController.loadUserData(uid);
    userController.formController.reverse();
    Get.offAll(MenuMainScreen());
  }

  _checkErrorExceedLimitPhoneVerify(String error) {
    userController.isShowLoading.value = false;

    if (error.contains('interrupted connection')) {
      userController.msgError.value =
          FlutterLocalizations.of(context).getString(context, 'no_connection');
    } else if (error.contains('blocked')) {
      userController.msgError.value = FlutterLocalizations.of(context)
          .getString(context, 'block_phoneNumber');
    } else if (error.contains('TOO_LONG')) {
      userController.msgError.value = FlutterLocalizations.of(context)
          .getString(context, 'incorret_phoneInput_long');
    } else if (error.contains('TOO_SHORT')) {
      userController.msgError.value = FlutterLocalizations.of(context)
          .getString(context, 'incorret_phoneInput_short');
    }
  }

  _navigateToVerifyPhoneNumber() async {
    Get.toNamed('/VerifyPhoneNumberScreen',
        arguments: '${Routes.verifyPhoneNumberScreen}'
            '?${Constants.PHONE_NUMBER}=${userController.user.value.phoneNumber.trim()}');
  }

  _onNavigateToCollectInformationScreen(data) {
    hideKeyboard(context);
    userController.msgError.value = '';

    userController.firebaseUser = data.user;
    Get.offAll(CollectCustomerInformationScreen(isVerifyPhone: true));
  }

  _showDialogAutoVerify() {
    userController.isShowLoading.value = false;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(FlutterLocalizations.of(context)
              .getString(context, 'auto_verify')),
          content: Text(FlutterLocalizations.of(context)
              .getString(context, 'auto_verify_content')),
        );
      },
    );
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

  void _addNoteModalBottomSheet(context) {
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: nameTextEditingController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.add_comment_outlined),
                            hintText: 'Enter note name',
                          ),
                        ),
                        ListTile(
                          leading: AppText(text: 'Category'),
                          trailing: DropdownButton(
                            hint: AppText(text: 'Select category'),
                            value: noteController.currentCategory.value,
                            items: _dropDownCategory,
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
                            items: _dropDownPriority,
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
                            items: _dropDownStatus,
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
                                    text: '${formatDate(noteController.pickedDate.value)}')
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
                                FlutterLocalizations.of(context)
                                    .getString(context, 'confirm'),
                                onTap: noteController.isUpdate.value==false?() async{
                                  Get.back();

                                  await noteController.addNote(
                                      nameTextEditingController.text,
                                      noteController.currentCategory.value,
                                      noteController.currentPriority.value,
                                      noteController.currentStatus.value,
                                      noteController.pickedDate.value,
                                      userController.user.value);

                                  noteController.listNotes.clear();

                                  await noteController.getAllNotes(userController.user.value);

                                  nameTextEditingController.text='';
                                  noteController.currentCategory.value=_dropDownCategory[0].value;
                                  noteController.currentPriority.value=_dropDownPriority[0].value;
                                  noteController.currentStatus.value=_dropDownStatus[0].value;
                                  noteController.pickedDate.value=null;
                                }:(){},
                              ),
                            ),
                          ),
                        )
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
