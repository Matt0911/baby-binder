import 'package:baby_binder/events/event_dialog.dart';
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
                      0,
                      createEventFromData(
                        docChange.doc.data() ?? {},
                        docChange.doc.id,
                      ));
                } else if (docChange.type == DocumentChangeType.removed) {
                  // TODO: event edited
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
    if (event.buildDialog != null) {
      EventDialogResult? result = await showModalBottomSheet(
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
              child: event.buildDialog!(context),
            ),
          ),
        ),
      );
      if (result == EventDialogResult.Save) {
        _addEvent(event);
      }
    } else {
      _addEvent(event);
    }
  }

  void _editEvent(StoryEvent event) {
    if (_document != null) {
      _document!
          .collection('events')
          .doc(event.id)
          .update(event.convertToMap());
    }
  }

  void _deleteEvent(StoryEvent event) {
    if (_document != null) {
      _document!.collection('events').doc(event.id).delete();
    }
  }

  void editEvent(StoryEvent event, BuildContext context) async {
    bool eventHasCustomDialog = event.buildDialog != null;
    EventDialogResult? result = await showModalBottomSheet(
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
            height: eventHasCustomDialog ? 400 : 200,
            child: eventHasCustomDialog
                ? event.buildDialog!(context, isEdit: true)
                : EventDialog(
                    title: event.eventType.title,
                    content: (Function(Function()) blank) => SizedBox(),
                    isEdit: true,
                    event: event,
                  ),
          ),
        ),
      ),
    );
    if (result == EventDialogResult.Save) {
      _editEvent(event);
    } else if (result == EventDialogResult.Delete) {
      _deleteEvent(event);
    }
  }
}
