import 'package:baby_binder/events/story_events.dart';
import 'package:baby_binder/providers/children_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                  events.insert(
                      0, createEventFromData(docChange.doc.data() ?? {}));
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

  void _addEvent(StoryEvent event) {
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

  void addNewEvent(EventType eventType, BuildContext context) async {
    StoryEvent event = createEventFromType(eventType);
    if (event.buildAddDialog != null) {
      List results = await showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        context: context,
        builder: (BuildContext context) => SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10)
                .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: event.buildAddDialog!(context),
            ),
          ),
        ),
      );
      bool didSave = results[0];
      if (didSave) {
        _addEvent(event);
      } else {
        print('user cancelled');
      }
    } else {
      _addEvent(event);
    }
  }
}
