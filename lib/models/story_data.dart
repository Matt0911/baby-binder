import 'package:baby_binder/events/sleep_events.dart';
import 'package:baby_binder/events/story_events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class StoryData {
  StoryData();
  StoryData.fromData(List<dynamic> events)
      : _events = events.map((e) => populateEvent(e)).toList();

  List<StoryEvent> _events = [];
  bool _isSleeping = true;

  List<StoryEvent> getEvents() => _events;
  void addEvent(StoryEvent event) {
    _events.insert(0, event);
    EventType type = event.eventType;
    if (type == EventType.started_sleeping) _isSleeping = true;
    if (type == EventType.ended_sleeping) _isSleeping = false;
  }

  bool isSleeping() => _isSleeping;
}
