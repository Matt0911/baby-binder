import 'dart:async';

import 'package:baby_binder/providers/story_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

final childDataProvider = ChangeNotifierProvider((ref) => ChildData());

class ChildData extends ChangeNotifier {
  ChildData() {
    _init();
    // firestore.clearPersistence();
  }

  _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
          final savedChildId = prefs.getString('activeChildId');
          if (savedChildId != null &&
              _children.indexWhere((element) => element.id == savedChildId) !=
                  -1) {
            setActiveChild(id: savedChildId);
          }
          notifyListeners();
        });
      } else {
        _children = [];
        activeChild = null;
        _childrenListSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  setActiveChild({required String id}) async {
    if (activeChild == null || id != activeChild?.id) {
      activeChild = _children.firstWhere((child) => child.id == id);
      _activeChildSubscription?.cancel();
      _activeChildSubscription =
          firestore.doc('children/$id').snapshots().listen(
        (snapshot) {
          activeChild!._updateData(snapshot.data());
          notifyListeners();
        },
      );
      notifyListeners();
    }
  }

  StreamSubscription<QuerySnapshot>? _childrenListSubscription;
  StreamSubscription<DocumentSnapshot>? _activeChildSubscription;
  List<Child> _children = [];
  List<Child> get children => _children;
  Child? activeChild;
}

final DateFormat _formatter = DateFormat();

class Child {
  Child.manual({required String id, required this.name, required this.image})
      : _id = id,
        document = firestore.collection('children').doc(id);

  Child(String id, Map<String, dynamic>? data)
      : _id = id,
        document = firestore.collection('children').doc(id) {
    _updateData(data);
  }

  void _updateData(Map<String, dynamic>? data) {
    if (data != null) {
      rawData = data;
      name = data['name'];
      image = data['image'];
      Timestamp? t = data['birthdate'] as Timestamp?;
      if (t != null) {
        birthdate = t.toDate();
      }
    }
  }

  final String _id;
  String get id => _id;
  Map<String, dynamic>? rawData;

  DocumentReference<Map<String, dynamic>> document;

  late String name;
  late String image;
  late bool isSleeping;

  DateTime? birthdate;
  bool get isBorn => birthdate != null;

  StoryData? story;

  void updateName(String name) {
    document.update({'name': name});
  }
}
