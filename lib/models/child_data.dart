import 'package:flutter/material.dart';

Map<int, dynamic> children = {
  1: {
    'name': 'Elliott',
  },
  2: {
    'name': 'Elinor',
  }
};

class ChildData extends ChangeNotifier {
  ChildData({required int id}) : _id = id {
    _initData();
  }

  _initData() {
    name = children[_id]['name'];
    notifyListeners();
  }

  int _id;
  late String name;
}
