import 'dart:async';

import 'package:baby_binder/events/sleep_events.dart';
import 'package:baby_binder/events/story_events.dart';
import 'package:baby_binder/providers/children_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

final storyDataProvider = ChangeNotifierProvider((ref) {
  final activeChild = ref.watch(activeChildProvider);
  return StoryData(
      activeChild?.rawData?['isSleeping'] ?? false, activeChild?.document);
});

class StoryData extends ChangeNotifier {
  StoryData(this.isSleeping, DocumentReference<Map<String, dynamic>>? document)
      : _document = document {
    if (_document != null) {
      _document!.collection('events').orderBy('time').snapshots().listen(
            (snapshot) => snapshot.docChanges.forEach(
              (docChange) {
                if (docChange.type == DocumentChangeType.added) {
                  events.insert(0, populateEvent(docChange.doc.data() ?? {}));
                } else if (docChange.type == DocumentChangeType.removed) {
                  events.removeWhere((c) => c.id == docChange.doc.id);
                }
                notifyListeners();
              },
            ),
          );
    }
  }

  List<StoryEvent> events = [];
  bool isSleeping = false;
  DocumentReference<Map<String, dynamic>>? _document;

  void addEvent(StoryEvent event) {
    // _events.insert(0, event);
    if (_document != null) {
      _document!.collection('events').add(event.convertToMap());
      if (event.eventType == EventType.started_sleeping ||
          event.eventType == EventType.ended_sleeping) {
        isSleeping = event.eventType == EventType.started_sleeping;
        _document!.update({'isSleeping': isSleeping});
      }
    }
  }
}
