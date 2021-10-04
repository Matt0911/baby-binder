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
          emptyBuilder,
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
          emptyBuilder,
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
          emptyBuilder,
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
          emptyBuilder,
        );
}
