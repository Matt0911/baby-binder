import 'package:flutter/material.dart';
import 'story_events.dart';
import 'add_event_dialog.dart';

class DiaperEvent extends StoryEvent {
  bool wet = false;
  bool bm = false;
  bool cream = false;
  bool diarrhea = false;
  String note = '';
  late Widget Function(BuildContext context)? buildAddDialog =
      (context) => AddEventDialog(
          title: EventType.diaper.description,
          content: (Map eventData, Function updateEventData) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ToggleButtons(
                    isSelected: [wet && !bm, bm && !wet, wet && bm],
                    borderRadius: BorderRadius.circular(10),
                    onPressed: (selected) {
                      wet = selected == 0 || selected == 2;
                      bm = selected == 1 || selected == 2;
                      if (selected == 0) {
                        diarrhea = false;
                      }
                      updateEventData({
                        'wet': selected == 0 || selected == 2,
                        'bm': selected == 1 || selected == 2,
                        ...(selected == 0 && eventData.containsKey('diarrhea')
                            ? {'diarrhea': false}
                            : {})
                      });
                    },
                    children: [Text('#1'), Text('#2'), Text('Both')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Applied cream?'),
                      Switch(
                        value: cream,
                        onChanged: (selected) {
                          cream = selected;
                          updateEventData({'cream': selected});
                        },
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
                            ? (selected) {
                                diarrhea = selected;
                                updateEventData({'diarrhea': selected});
                              }
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
                          onChanged: (note) {
                            this.note = note;
                            updateEventData({'note': note});
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ));

  DiaperEvent()
      : super(
          EventType.diaper,
          DateTime.now(),
          EventType.diaper.description,
          EventType.diaper.icon,
          EventType.diaper.iconColor,
          EventType.diaper.backgroundColor,
          true,
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
        );

  @override
  Map<String, dynamic> convertToMap() => {
        ...super.convertToMap(),
      };
}
