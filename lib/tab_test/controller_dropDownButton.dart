import 'package:flutter/foundation.dart';

enum DropDownType { current, another }

class MyDropdownMenuController extends ChangeNotifier {
  double dropDownHeaderHeight;
  double width = 50;

  int menuIndex = 0;

  bool isShow = false;

  bool isShowHideAnimation = false;

  DropDownType dropDownType;

  void show() {
    isShow = true;
    notifyListeners();
  }

  void hide({bool isShowHideAnimation = true}) {
    this.isShowHideAnimation = isShowHideAnimation;
    isShow = false;
    notifyListeners();
  }
}
