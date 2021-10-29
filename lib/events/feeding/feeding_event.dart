import 'package:flutter/material.dart';
import '../story_events.dart';
import '../add_event_dialog.dart';
import 'bottle_tab.dart';
import 'nursing_tab.dart';
import 'solids_tab.dart';

class FeedingDialogContent extends StatelessWidget {
  const FeedingDialogContent(
      {Key? key, required this.eventData, required this.updateEventData})
      : super(key: key);
  final Map eventData;
  final Function updateEventData;

  @override
  Widget build(BuildContext context) {
    // bool cream = eventData['cream'] ?? false;
    // bool diarrhea = eventData['diarrhea'] ?? false;
    return Expanded(
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
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
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
    );
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
          title: EventType.feeding.description,
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
