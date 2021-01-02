import 'package:app_note/constants/constants.dart';
import 'package:app_note/screen/dashboard_screen/dashboard_screen.dart';
import 'package:app_note/screen/main_screen/main_screen.dart';
import 'package:app_note/screen/setting_screen/setting_screen.dart';
import 'package:app_note/widget/animate_menu.dart';
import 'package:app_note/widget/menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class MenuMainScreen extends StatefulWidget {

  const MenuMainScreen({Key key}) : super(key: key);

  @override
  _MenuMainScreenState createState() => _MenuMainScreenState();
}

class _MenuMainScreenState extends State<MenuMainScreen> {
  final menu =  Menu(
    items: [
      MenuItem(
        id: Constants.MY_MAIN_SCREEN_ID,
        title: 'Main',
      ),
      MenuItem(
        id: Constants.MY_DASH_BOARD_ID,
        title: 'Dash Board',
      ),
    ],
  );

  Rx<int> selectedMenuItemId = Rx<int>(Constants.MY_MAIN_SCREEN_ID);
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: _buildContentView(),
      ),
    );
  }

  _buildContentView() {
    return Obx((){
      return ZoomScaffold(
        menuScreen: MenuScreen(
          menu: menu,
          selectedItemId: selectedMenuItemId.value,
          onMenuItemSelected: (int screenId) {
            switch (screenId) {
              case Constants.MY_MAIN_SCREEN_ID:
                selectedMenuItemId.value = Constants.MY_MAIN_SCREEN_ID;
                break;
              case Constants.MY_DASH_BOARD_ID:
                selectedMenuItemId.value = Constants.MY_DASH_BOARD_ID;
                break;
              default:

            }
          },
        ),
        contentScreens: [myMainScreen,myDashBoardScreen],
        screenSelected: selectedMenuItemId.value,
      );
    });
  }
}