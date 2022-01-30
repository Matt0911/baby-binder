import 'package:cloud_firestore/cloud_firestore.dart';
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
          event: this,
          title: EventType.diaper.description,
          content: (
            Map eventData,
            Function(Function()) updateEventData,
          ) =>
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ToggleButtons(
                    isSelected: [wet && !bm, bm && !wet, wet && bm],
                    borderRadius: BorderRadius.circular(10),
                    onPressed: (selected) {
                      updateEventData(() {
                        wet = selected == 0 || selected == 2;
                        bm = selected == 1 || selected == 2;
                        if (selected == 0) {
                          diarrhea = false;
                        }
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
                          updateEventData(() => cream = selected);
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
                                updateEventData(() => diarrhea = selected);
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
                            updateEventData(() => this.note = note);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ));

  DiaperEvent()
      : super(
          eventType: EventType.diaper,
          eventTime: DateTime.now(),
        );

  DiaperEvent.fromData(Map<String, dynamic> data)
      : wet = data['wet'],
        bm = data['bm'],
        cream = data['cream'],
        diarrhea = data['diarrhea'],
        note = data['note'],
        super(
          eventType: EventType.diaper,
          eventTime: (data['time'] as Timestamp).toDate(),
        );

  DiaperEvent.withTime({
    required eventTime,
  }) : super(
          eventType: EventType.diaper,
          eventTime: eventTime,
        );

  @override
  Map<String, dynamic> convertToMap() => {
        ...super.convertToMap(),
        'wet': wet,
        'bm': bm,
        'cream': cream,
        'diarrhea': diarrhea,
        'note': note,
      };
}
