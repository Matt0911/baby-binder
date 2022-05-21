
import 'story_events.dart';

class StartSleepEvent extends StoryEvent {
  StartSleepEvent()
      : super(
          eventType: EventType.started_sleeping,
          eventTime: DateTime.now(),
        );

  StartSleepEvent.fromData(Map<String, dynamic> data, String? id)
      : super(
          eventType: EventType.started_sleeping,
          eventTime: castDate(data['time']),
          id: id,
        );

  StartSleepEvent.withTime({
    required eventTime,
  }) : super(
          eventType: EventType.started_sleeping,
          eventTime: eventTime,
        );

  @override
  String getTimelineDescription() {
    return 'Started sleeping';
  }
}

class EndSleepEvent extends StoryEvent {
  EndSleepEvent()
      : super(
          eventType: EventType.ended_sleeping,
          eventTime: DateTime.now(),
        );

  EndSleepEvent.fromData(Map<String, dynamic> data, String? id)
      : super(
          eventType: EventType.ended_sleeping,
          eventTime: castDate(data['time']),
          id: id,
        );

  EndSleepEvent.withTime({
    required eventTime,
  }) : super(
          eventType: EventType.ended_sleeping,
          eventTime: eventTime,
        );

  @override
  String getTimelineDescription() {
    return 'Woke up';
  }
}
