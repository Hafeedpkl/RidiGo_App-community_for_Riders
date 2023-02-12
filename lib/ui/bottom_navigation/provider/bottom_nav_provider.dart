import 'package:flutter/material.dart';

class BottomNavProvider extends ChangeNotifier {
  int selectedIndex = 0;
  void bottomChanger(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
