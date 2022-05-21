import 'package:flutter/material.dart';
import 'story_events.dart';
import 'event_dialog.dart';

class DiaperEvent extends StoryEvent {
  bool wet = false;
  bool bm = false;
  bool cream = false;
  bool diarrhea = false;
  String note = '';
  @override
  late Widget Function(BuildContext context, {bool isEdit})? buildDialog =
      (context, {isEdit = false}) => EventDialog(
          // TODO: fix styling
          title: EventType.diaper.title,
          isEdit: isEdit,
          event: this,
          content: (
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
                    children: const [Text('#1'), Text('#2'), Text('Both')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Applied cream?'),
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
                      const Text('Diarrhea?'),
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
                      const Text('Notes'),
                      const SizedBox(width: 20),
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

  DiaperEvent.fromData(Map<String, dynamic> data, String? id)
      : wet = data['wet'],
        bm = data['bm'],
        cream = data['cream'],
        diarrhea = data['diarrhea'],
        note = data['note'],
        super(
          eventType: EventType.diaper,
          eventTime: castDate(data['time']),
          id: id,
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

  @override
  String getTimelineDescription() {
    String diaperDesc =
        '${wet ? '#1' : ''}${wet && bm ? ' & ' : ''}${bm ? '#2' : ''}';
    return '$diaperDesc${cream ? ', Cream' : ''}${diarrhea ? ', Diarrhea' : ''}${note != '' ? ', $note' : ''}';
  }
}
