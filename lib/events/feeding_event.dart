import 'package:flutter/material.dart';
import 'story_events.dart';
import 'add_event_dialog.dart';

class FeedingDialogContent extends StatelessWidget {
  const FeedingDialogContent({
    Key? key,
    required this.eventData,
    required this.updateEventData,
  }) : super(key: key);
  final Map eventData;
  final Function updateEventData;

  @override
  Widget build(BuildContext context) {
    return Text('feeding');
  }
}

Widget _buildFeedingDialogContent(Map eventData, Function updateEventData) {
  return FeedingDialogContent(
    eventData: eventData,
    updateEventData: updateEventData,
  );
}

final Widget Function(Function? onSave) _feedingDialogBuilder =
    (onSave) => AddEventDialog(
          title: EventType.diaper.description,
          content: _buildFeedingDialogContent,
        );

class FeedingEvent extends StoryEvent {
  FeedingEvent()
      : super(
          EventType.feeding,
          DateTime.now(),
          EventType.feeding.description,
          EventType.feeding.icon,
          EventType.feeding.iconColor,
          EventType.feeding.backgroundColor,
          true,
          _feedingDialogBuilder,
        );

  FeedingEvent.withTime({
    required eventTime,
  }) : super(
          EventType.feeding,
          eventTime,
          EventType.feeding.description,
          EventType.feeding.icon,
          EventType.feeding.iconColor,
          EventType.feeding.backgroundColor,
          true,
          _feedingDialogBuilder,
        );
}
