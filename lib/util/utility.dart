import 'package:PureBook/common/Screen.dart';
import 'package:flutter/widgets.dart';


afterLayout(VoidCallback callback) {
  WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
    callback();
  });
}

fixedFontSize(double fontSize) {
  return fontSize / Screen.textScaleFactor;
}
