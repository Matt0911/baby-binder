import 'package:flutter/material.dart';

Map<int, dynamic> children = {
  1: {
    'name': 'Elliott',
    'image': 'images/Elliott.jpg',
  },
  2: {
    'name': 'Elinor',
    'image': 'images/Elinor.jpg',
  }
};

class ChildData extends ChangeNotifier {
  ChildData({required int id}) : _id = id {
    _initData();
  }

  _initData() {
    name = children[_id]['name'];
    image = children[_id]['image'];
    notifyListeners();
  }

  changeChild({required int id}) {
    _id = id;
    _initData();
  }

  int _id;
  int get id => _id;
  late String name;
  late String image;
}
