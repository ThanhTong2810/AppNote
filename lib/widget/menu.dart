import 'package:app_note/controller/user_controller.dart';
import 'package:app_note/localization/flutter_localizations.dart';
import 'package:app_note/screen/setting_screen/setting_screen.dart';
import 'package:app_note/theme/colors.dart';
import 'package:app_note/theme/dimens.dart';
import 'package:app_note/utils/utils.dart';
import 'package:app_note/widget/animate_menu.dart';
import 'package:app_note/widget/app_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class MenuScreen extends StatefulWidget {
  final Menu menu;
  final int selectedItemId;
  final Function(int) onMenuItemSelected;

  const MenuScreen(
      {Key key,
      this.menu,
      this.selectedItemId,
      this.onMenuItemSelected,})
      : super(key: key);

  @override
  _MenuScreenState createState() => new _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  final UserController userController=Get.find();
  AnimationController titleAnimationController;
  double selectorYTop;
  double selectorYBottom;

  setSelectedRenderBox(RenderBox newRenderBox) async {
    final newYTop = newRenderBox.localToGlobal(const Offset(0.0, 0.0)).dy;
    final newYBottom = newYTop + newRenderBox.size.height;
    if (newYTop != selectorYTop) {
      setState(() {
        selectorYTop = newYTop;
        selectorYBottom = newYBottom;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    titleAnimationController = new AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  @override
  void dispose() {
    titleAnimationController.dispose();
    super.dispose();
  }

  createMenuTitle(MenuController menuController) {
    switch (menuController.state) {
      case MenuState.open:
      case MenuState.opening:
        titleAnimationController.forward();
        break;
      case MenuState.closed:
      case MenuState.closing:
        titleAnimationController.reverse();
        break;
    }

    return AnimatedBuilder(
        animation: titleAnimationController,
        child: OverflowBox(
          maxWidth: double.infinity,
          alignment: Alignment.topLeft,
          child: Container(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _navigateToSettingsScreen();
                  },
                  child: Container(
                    child: SizedBox(
                      height: getScreenHeight(context) / 8,
                      width:getScreenHeight(context) / 8 ,
                      child: CachedNetworkImage(
                        width: getScreenWidth(context),
                        fit: BoxFit.fitWidth,
                        imageUrl: userController.user.value.imgURL ?? '',
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          backgroundImage: imageProvider,
                        ),
                        placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[400],
                            highlightColor: Colors.white,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                            )),
                        errorWidget: (context, url, error) => Icon(Icons.person),
                      ),
                    ),
                  ),
                ),
                Dimens.height10,
                AppText(text: userController.user.value.displayName??'',color: AppColors.white,)
              ],
            ),
          ),
        ),
        builder: (BuildContext context, Widget child) {
          return Transform(
            transform: Matrix4.translationValues(
              250.0 * (1.0 - titleAnimationController.value),
              0.0,
              0.0,
            ),
            child: child,
          );
        });
  }

  _navigateToSettingsScreen(){
    Get.to(SettingScreen());
  }

  createMenuItems(MenuController menuController) {
    final List<Widget> listItems = [];
    final animationIntervalDuration = 0.5;
    final perListItemDelay =
        menuController.state != MenuState.closing ? 0.15 : 0.0;
    for (var i = 0; i < widget.menu.items.length; ++i) {
      final animationIntervalStart = i * perListItemDelay;
      final animationIntervalEnd =
          animationIntervalStart + animationIntervalDuration;
      final isSelected = widget.menu.items[i].id == widget.selectedItemId;

      listItems.add(AnimatedMenuListItem(
        menuState: menuController.state,
        isSelected: isSelected,
        duration: const Duration(milliseconds: 600),
        curve: Interval(animationIntervalStart, animationIntervalEnd,
            curve: Curves.easeOut),
        menuListItem: _MenuListItem(
          title: widget.menu.items[i].title,
          isSelected: isSelected,
          onTap: () {
            widget.onMenuItemSelected(widget.menu.items[i].id);
            menuController.close();
          },
        ),
      ));
    }

    return Transform(
      transform: Matrix4.translationValues(
        0.0,
        225.0,
        0.0,
      ),
      child: Column(
        children: listItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ZoomScaffoldMenuController(
        builder: (BuildContext context, MenuController menuController) {
      var shouldRenderSelector = true;
      var actualSelectorYTop = selectorYTop;
      var actualSelectorYBottom = selectorYBottom;
      var selectorOpacity = 1.0;

      if (menuController.state == MenuState.closed ||
          menuController.state == MenuState.closing ||
          selectorYTop == null) {
        final menuScreenHeight = getScreenHeight(context);
        actualSelectorYTop = menuScreenHeight - 50.0;
        actualSelectorYBottom = menuScreenHeight;
        selectorOpacity = 0.0;
      }

      return new Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: AppColors.gradientColorPrimary)),
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              createMenuTitle(menuController),
              createMenuItems(menuController),
              shouldRenderSelector
                  ? ItemSelector(
                      topY: actualSelectorYTop,
                      bottomY: actualSelectorYBottom,
                      opacity: selectorOpacity,
                    )
                  : Container(),
            ],
          ),
        ),
      );
    });
  }
}

class ItemSelector extends ImplicitlyAnimatedWidget {
  final double topY;
  final double bottomY;
  final double opacity;

  ItemSelector({
    this.topY,
    this.bottomY,
    this.opacity,
  }) : super(duration: const Duration(milliseconds: 250));

  @override
  _ItemSelectorState createState() => new _ItemSelectorState();
}

class _ItemSelectorState extends AnimatedWidgetBaseState<ItemSelector> {
  Tween<double> _topY;
  Tween<double> _bottomY;
  Tween<double> _opacity;

  @override
  void forEachTween(TweenVisitor visitor) {
    _topY = visitor(
      _topY,
      widget.topY,
      (dynamic value) => Tween<double>(begin: value),
    );
    _bottomY = visitor(
      _bottomY,
      widget.bottomY,
      (dynamic value) => Tween<double>(begin: value),
    );
    _opacity = visitor(
      _opacity,
      widget.opacity,
      (dynamic value) => Tween<double>(begin: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      top: _topY.evaluate(animation),
      child: new Opacity(
        opacity: _opacity.evaluate(animation),
        child: new Container(
          width: 5.0,
          height: _bottomY.evaluate(animation) - _topY.evaluate(animation),
          color: Colors.red,
        ),
      ),
    );
  }
}

class AnimatedMenuListItem extends ImplicitlyAnimatedWidget {
  final _MenuListItem menuListItem;
  final MenuState menuState;
  final bool isSelected;
  final Duration duration;

  AnimatedMenuListItem({
    this.menuListItem,
    this.menuState,
    this.isSelected,
    this.duration,
    curve,
  }) : super(duration: duration, curve: curve);

  @override
  _AnimatedMenuListItemState createState() => new _AnimatedMenuListItemState();
}

class _AnimatedMenuListItemState
    extends AnimatedWidgetBaseState<AnimatedMenuListItem> {
  final double closedSlidePosition = 200.0;
  final double openSlidePosition = 0.0;

  Tween<double> _translation;
  Tween<double> _opacity;

  @override
  void forEachTween(TweenVisitor visitor) {
    var slide, opacity;

    switch (widget.menuState) {
      case MenuState.closed:
      case MenuState.closing:
        slide = closedSlidePosition;
        opacity = 0.0;
        break;
      case MenuState.open:
      case MenuState.opening:
        slide = openSlidePosition;
        opacity = 1.0;
        break;
    }

    _translation = visitor(
      _translation,
      slide,
      (dynamic value) => new Tween<double>(begin: value),
    );

    _opacity = visitor(
      _opacity,
      opacity,
      (dynamic value) => new Tween<double>(begin: value),
    );
  }

  @override
  Widget build(BuildContext context) {

    return new Opacity(
      opacity: _opacity.evaluate(animation),
      child: new Transform(
        transform: new Matrix4.translationValues(
          0.0,
          _translation.evaluate(animation),
          0.0,
        ),
        child: widget.menuListItem,
      ),
    );
  }
}

class _MenuListItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function() onTap;

  _MenuListItem({
    this.title,
    this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0, top: 15.0, bottom: 15.0),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? AppColors.selectedMenu : AppColors.white,
              fontSize: 25.0,
              fontFamily: 'Lato',
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}

class Menu {
  final List<MenuItem> items;

  Menu({
    this.items,
  });
}

class MenuItem {
  final int id;
  final String title;

  MenuItem({
    this.id,
    this.title,
  });
}
