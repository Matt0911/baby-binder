import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:intl/intl.dart';

class ChildStory extends StatefulWidget {
  const ChildStory({Key? key}) : super(key: key);

  @override
  _ChildStoryState createState() => _ChildStoryState();
}

class _ChildStoryState extends State<ChildStory> {
  List<StoryEvent> events = [
    StoryEvent.withTime(EventType.diaper, DateTime.utc(2021, 9, 25, 15)),
    StoryEvent.withTime(
        EventType.started_sleeping, DateTime.utc(2021, 9, 25, 16)),
  ];

  void _addEvent(EventType eventType) {
    setState(() {
      events.add(StoryEvent(eventType));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 3,
            child: Timeline.tileBuilder(
              builder: TimelineTileBuilder.connected(
                contentsAlign: ContentsAlign.basic,
                contentsBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(events[index].getDescription()),
                ),
                oppositeContentsBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(events[index].getFormattedTime()),
                ),
                // nodePositionBuilder: (context, index) => 0.4,
                // indicatorPositionBuilder: (context, index) => 0.0,
                connectorBuilder: (context, index, connectorType) {
                  return events[index].getEventType() ==
                          EventType.started_sleeping
                      ? SolidLineConnector(
                          color: Colors.green,
                        )
                      : SolidLineConnector(
                          color: Colors.blue,
                        );
                },
                indicatorBuilder: (context, index) {
                  EventType type = events[index].getEventType();
                  return type == EventType.started_sleeping ||
                          type == EventType.ended_sleeping
                      ? DotIndicator(
                          color: Colors.green,
                        )
                      : DotIndicator(
                          color: Colors.blue,
                        );
                },
                itemCount: events.length,
              ),
            )),
        Expanded(
          flex: 2,
          child: Material(
            color: Colors.teal[50],
            child: GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 15,
              padding: EdgeInsets.all(16.0),
              children: [
                Ink(
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: Colors.green[50],
                  ),
                  child: IconButton(
                      color: Colors.green,
                      onPressed: () => _addEvent(EventType.ended_sleeping),
                      icon: Icon(
                        Icons.crib,
                        size: 48,
                      )),
                ),
                Ink(
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: Colors.red[50],
                  ),
                  child: IconButton(
                      color: Colors.red,
                      onPressed: () => _addEvent(EventType.diaper),
                      icon: Icon(
                        Icons.baby_changing_station,
                        size: 48,
                      )),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum EventType {
  diaper,
  started_sleeping,
  ended_sleeping,
}

extension Event on EventType {
  String get description {
    switch (this) {
      case EventType.diaper:
        return 'Diaper';
      case EventType.started_sleeping:
        return 'Started sleeping';
      case EventType.ended_sleeping:
        return 'Woke up';
      default:
        return '';
    }
  }
}

class StoryEvent {
  EventType _eventType;
  DateTime _eventTime = DateTime.now();
  final DateFormat formatter = DateFormat('MMM dd hh:mm a');

  StoryEvent(this._eventType);
  StoryEvent.withTime(this._eventType, this._eventTime);

  String getFormattedTime() => formatter.format(_eventTime.toLocal());
  DateTime getLocalTime() => _eventTime.toLocal();
  EventType getEventType() => _eventType;
  String getDescription() => _eventType.description;
}
