import 'dart:async';

import 'package:baby_binder/models/story_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class ChildData extends ChangeNotifier {
  ChildData() {
    _init();
  }

  _init() {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _childrenListSubscription = firestore
            .collection('children')
            // .where(field) TODO: only children with user ID
            .snapshots()
            .listen((snapshot) {
          snapshot.docChanges.forEach((docChange) {
            if (docChange.type == DocumentChangeType.added) {
              _children.add(
                Child(docChange.doc.id, docChange.doc.data()),
              );
            } else if (docChange.type == DocumentChangeType.removed) {
              _children.removeWhere((c) => c.id == docChange.doc.id);
            }
          });
          setActiveChild(id: _children[0].id);
          notifyListeners();
        });
      } else {
        _children = [];
        _activeChild = null;
        _childrenListSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  setActiveChild({required String id}) {
    if (_activeChild == null || id != _activeChild?.id) {
      _activeChildSubscription?.cancel();
      _activeChild = _children.firstWhere((child) => child.id == id);
      _activeChildSubscription =
          firestore.doc('children/$id').snapshots().listen((snapshot) {
        _activeChild!._updateData(snapshot.data());
        notifyListeners();
      });
      notifyListeners();
    }
  }

  StreamSubscription<QuerySnapshot>? _childrenListSubscription;
  StreamSubscription<DocumentSnapshot>? _activeChildSubscription;
  List<Child> _children = [];
  List<Child> get children => _children;
  Child? _activeChild;
  Child? get activeChild => _activeChild;
}

final DateFormat _formatter = DateFormat();

class Child {
  Child.manual({required String id, required this.name, required this.image})
      : _id = id;

  Child(String id, Map<String, dynamic>? data) : _id = id {
    _updateData(data);
  }

  void _updateData(Map<String, dynamic>? data) {
    if (data != null) {
      name = data['name'];
      image = data['image'];
      Timestamp? t = data['birthdate'] as Timestamp?;
      if (t != null) {
        birthdate = t.toDate();
      }
      List<dynamic>? events = data['events'];
      if (events != null) {
        this.story = StoryData.fromData(events);
      } else {
        this.story = StoryData();
      }
    }
  }

  final String _id;
  String get id => _id;

  late String name;

  late String image;

  DateTime? birthdate;
  bool get isBorn => birthdate != null;

  late StoryData story;

  void updateName(String name) {
    firestore.collection('children').doc(_id).update({'name': name});
  }
}
