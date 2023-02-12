import 'package:flutter/foundation.dart';

class RidesProvider extends ChangeNotifier{
   bool isExpand = false;
  void changeExpansion() {
    isExpand = !isExpand;
    notifyListeners();
  }

}