import "dart:ui" as ui show window;
import 'package:flutter/material.dart';

class UISize {
  static double get screenWidth {
    MediaQueryData uiWidth = MediaQueryData.fromWindow(ui.window);
    return uiWidth.size.width;
  }

  static double get screenHeight {
    MediaQueryData uiHeight = MediaQueryData.fromWindow(ui.window);
    return uiHeight.size.height;
  }

  static double get topHeight {
    MediaQueryData uiTopBarHeight = MediaQueryData.fromWindow(ui.window);
    return uiTopBarHeight.padding.top;
  }

  static double get bottomHeight {
    MediaQueryData uiBottomBarHeight = MediaQueryData.fromWindow(ui.window);
    return uiBottomBarHeight.padding.bottom;
  }
}