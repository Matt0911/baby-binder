import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  ChildData() {
    _init();
  }

  _init() {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        // Add from here
        _childrenListSubscription = FirebaseFirestore.instance
            .collection('children')
            // .where(field)
            .snapshots()
            .listen((snapshot) {
          _children = [];
          snapshot.docs.forEach((document) {
            print(document.id);
            _children.add(
              Child(
                id: document.id,
                name: document.data()['name'],
                image: document.data()['image'],
              ),
            );
          });
          _id = _children[0].id;
          name = _children[0].name;
          image = _children[0].image;
          notifyListeners();
        });
        // to here.
      } else {
        _children = [];
        _childrenListSubscription?.cancel();
      }
      notifyListeners();
    });
    notifyListeners();
  }

  changeChild({required String id}) {
    _id = id;
    _init();
  }

  late String _id;
  String get id => _id;
  late String name;
  late String image;

  StreamSubscription<QuerySnapshot>? _childrenListSubscription;
  List<Child> _children = [];
  List<Child> get children => _children;
}

class Child {
  Child({required String id, required this.name, required this.image})
      : _id = id;
  final String _id;
  String get id => _id;
  String name;
  String image;
}
