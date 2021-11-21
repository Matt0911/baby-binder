import 'package:cloud_firestore/cloud_firestore.dart';

import 'story_events.dart';

class StartSleepEvent extends StoryEvent {
  StartSleepEvent()
      : super(
          EventType.started_sleeping,
          DateTime.now(),
          EventType.started_sleeping.description,
          EventType.started_sleeping.icon,
          EventType.started_sleeping.iconColor,
          EventType.started_sleeping.backgroundColor,
          false,
        );

  StartSleepEvent.fromData(Map<String, dynamic> data)
      : super(
          EventType.started_sleeping,
          (data['time'] as Timestamp).toDate(),
          EventType.started_sleeping.description,
          EventType.started_sleeping.icon,
          EventType.started_sleeping.iconColor,
          EventType.started_sleeping.backgroundColor,
          false,
        );

  StartSleepEvent.withTime({
    required eventTime,
  }) : super(
          EventType.started_sleeping,
          eventTime,
          EventType.started_sleeping.description,
          EventType.started_sleeping.icon,
          EventType.started_sleeping.iconColor,
          EventType.started_sleeping.backgroundColor,
          false,
        );
}

class EndSleepEvent extends StoryEvent {
  EndSleepEvent()
      : super(
          EventType.ended_sleeping,
          DateTime.now(),
          EventType.ended_sleeping.description,
          EventType.ended_sleeping.icon,
          EventType.ended_sleeping.iconColor,
          EventType.ended_sleeping.backgroundColor,
          false,
        );

  EndSleepEvent.withTime({
    required eventTime,
  }) : super(
          EventType.ended_sleeping,
          eventTime,
          EventType.ended_sleeping.description,
          EventType.ended_sleeping.icon,
          EventType.ended_sleeping.iconColor,
          EventType.ended_sleeping.backgroundColor,
          false,
        );
}
