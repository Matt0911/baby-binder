import 'package:flutter/material.dart';
import 'story_events.dart';
import 'add_event_dialog.dart';

class DiaperDialogContent extends StatelessWidget {
  const DiaperDialogContent(
      {Key? key, required this.eventData, required this.updateEventData})
      : super(key: key);
  final Map eventData;
  final Function updateEventData;

  @override
  Widget build(BuildContext context) {
    bool wet = eventData['wet'] ?? false;
    bool bm = eventData['bm'] ?? false;
    bool cream = eventData['cream'] ?? false;
    bool diarrhea = eventData['diarrhea'] ?? false;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ToggleButtons(
          isSelected: [wet && !bm, bm && !wet, wet && bm],
          borderRadius: BorderRadius.circular(10),
          onPressed: (selected) => updateEventData({
            'wet': selected == 0 || selected == 2,
            'bm': selected == 1 || selected == 2,
            ...(selected == 0 && eventData.containsKey('diarrhea')
                ? {'diarrhea': false}
                : {})
          }),
          children: [Text('#1'), Text('#2'), Text('Both')],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Applied cream?'),
            Switch(
              value: cream,
              onChanged: (selected) => updateEventData({'cream': selected}),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Diarrhea?'),
            Switch(
              value: diarrhea,
              onChanged: bm
                  ? (selected) => updateEventData({'diarrhea': selected})
                  : null,
            ),
          ],
        ),
        Row(
          children: [
            Text('Notes'),
            SizedBox(width: 20),
            Expanded(
              child: TextField(
                onChanged: (note) => updateEventData({'note': note}),
              ),
            ),
          ],
        )
      ],
    );
  }
}

Widget _buildDiaperDialogContent(Map eventData, Function updateEventData) {
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
