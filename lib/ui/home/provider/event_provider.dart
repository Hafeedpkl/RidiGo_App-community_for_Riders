import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  bool isExpand = false;
  void changeExpansion() {
    isExpand = !isExpand;
    notifyListeners();
  }
}
