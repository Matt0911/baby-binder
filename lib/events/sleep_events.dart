import 'package:cloud_firestore/cloud_firestore.dart';

import 'story_events.dart';

class StartSleepEvent extends StoryEvent {
  StartSleepEvent()
      : super(
          eventType: EventType.started_sleeping,
          eventTime: DateTime.now(),
        );

  StartSleepEvent.fromData(Map<String, dynamic> data, String id)
      : super(
          eventType: EventType.started_sleeping,
          eventTime: (data['time'] as Timestamp).toDate(),
          id: id,
        );

  StartSleepEvent.withTime({
    required eventTime,
  }) : super(
          eventType: EventType.started_sleeping,
          eventTime: eventTime,
        );
}

class EndSleepEvent extends StoryEvent {
  EndSleepEvent()
      : super(
          eventType: EventType.ended_sleeping,
          eventTime: DateTime.now(),
        );

  EndSleepEvent.fromData(Map<String, dynamic> data, String id)
      : super(
          eventType: EventType.ended_sleeping,
          eventTime: (data['time'] as Timestamp).toDate(),
          id: id,
        );

  EndSleepEvent.withTime({
    required eventTime,
  }) : super(
          eventType: EventType.ended_sleeping,
          eventTime: eventTime,
        );
}
