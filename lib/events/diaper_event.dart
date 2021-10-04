import 'package:flutter/material.dart';
import 'story_events.dart';
import 'add_event_dialog.dart';

class DiaperDialogContent extends StatelessWidget {
  const DiaperDialogContent({
    Key? key,
    required this.eventData,
    required this.updateEventData,
  }) : super(key: key);
  final Map<String, dynamic> eventData;
  final Function updateEventData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('diaper'),
        TextButton(
            onPressed: () {
              updateEventData({
                'poopy':
                    eventData.containsKey('poopy') ? !eventData['poopy'] : true,
              });
            },
            child: Text('poop'))
      ],
    );
  }
}

Widget _buildDiaperDialogContent(
    Map<String, dynamic> eventData, Function updateEventData) {
  return DiaperDialogContent(
    eventData: eventData,
    updateEventData: updateEventData,
  );
}

final Widget Function(Function? onSave) _diaperDialogBuilder =
    (onSave) => AddEventDialog(
          title: EventType.diaper.description,
          content: _buildDiaperDialogContent,
        );

class DiaperEvent extends StoryEvent {
  DiaperEvent()
      : super(
          EventType.diaper,
          DateTime.now(),
          EventType.diaper.description,
          EventType.diaper.icon,
          EventType.diaper.iconColor,
          EventType.diaper.backgroundColor,
          true,
          _diaperDialogBuilder,
        );

  DiaperEvent.withTime({
    required eventTime,
  }) : super(
          EventType.diaper,
          eventTime,
          EventType.diaper.description,
          EventType.diaper.icon,
          EventType.diaper.iconColor,
          EventType.diaper.backgroundColor,
          true,
          _diaperDialogBuilder,
        );
}
