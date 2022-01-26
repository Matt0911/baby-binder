import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../story_events.dart';
import '../add_event_dialog.dart';
import 'bottle_tab.dart';
import 'nursing_tab.dart';
import 'solids_tab.dart';

class FeedingEvent extends StoryEvent {
  late Widget Function(BuildContext context)? buildAddDialog =
      (context) => AddEventDialog(
            title: EventType.feeding.description,
            content: (Map eventData, Function updateEventData) => Expanded(
              child: DefaultTabController(
                initialIndex: 0,
                length: 3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: 'Nursing'),
                        Tab(text: 'Bottle'),
                        Tab(text: 'Solids')
                      ],
                      labelColor: Colors.teal,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      unselectedLabelStyle:
                          TextStyle(fontWeight: FontWeight.normal),
                    ),
                    Expanded(
                      child: TabBarView(children: [
                        NursingTab(),
                        BottleTab(
                          eventData: eventData,
                          updateEventData: updateEventData,
                        ),
                        SolidTab(),
                      ]),
                    )
                  ],
                ),
              ),
            ),
          );

  FeedingEvent()
      : super(
          eventType: EventType.feeding,
          eventTime: DateTime.now(),
        );

  FeedingEvent.fromData(Map<String, dynamic> data)
      : super(
          eventType: EventType.feeding,
          eventTime: (data['time'] as Timestamp).toDate(),
        );

  FeedingEvent.withTime({
    required eventTime,
  }) : super(
          eventType: EventType.feeding,
          eventTime: eventTime,
        );
}
