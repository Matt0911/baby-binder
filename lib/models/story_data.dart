import 'dart:async';

import 'package:baby_binder/events/sleep_events.dart';
import 'package:baby_binder/events/story_events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class StoryData {
  StoryData(Map<String, dynamic> data,
      DocumentReference<Map<String, dynamic>> document, Function? onChange)
      : _document = document,
        _isSleeping = data['isSleeping'] ?? false {
    document
        .collection('events')
        .orderBy('time')
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((docChange) {
        if (docChange.type == DocumentChangeType.added) {
          _events.insert(0, populateEvent(docChange.doc.data() ?? {}));
        } else if (docChange.type == DocumentChangeType.removed) {
          _events.removeWhere((c) => c.id == docChange.doc.id);
        }
      });
      onChange!();
    });
  }

  List<StoryEvent> _events = [];
  bool _isSleeping = false;
  DocumentReference<Map<String, dynamic>> _document;

  List<StoryEvent> getEvents() => _events;
  void addEvent(StoryEvent event) {
    // _events.insert(0, event);
    _document.collection('events').add(event.convertToMap());
    if (event.eventType == EventType.started_sleeping ||
        event.eventType == EventType.ended_sleeping) {
      _isSleeping = event.eventType == EventType.started_sleeping;
      _document.update({'isSleeping': _isSleeping});
    }
  }

  bool isSleeping() => _isSleeping;
}
