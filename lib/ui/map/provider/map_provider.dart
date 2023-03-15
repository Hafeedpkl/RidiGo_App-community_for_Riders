import 'package:flutter/material.dart';
import 'package:ridigo/core/services/all_services.dart';

import '../model/map_model.dart';

class MapProvider with ChangeNotifier {
  var currentLocation;
  List<MapModel>? mapMarkerList;

  void getMapMarks() async {
    await AllServices().getMapPins().then((value) {
      mapMarkerList = value;
      notifyListeners();
    });
  }
}
