import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:intl/intl.dart';

class ChildStory extends StatefulWidget {
  const ChildStory({Key? key}) : super(key: key);

  @override
  _ChildStoryState createState() => _ChildStoryState();
}

class _ChildStoryState extends State<ChildStory> {
  StoryData story = StoryData();
  void _addEvent(EventType type) {
    setState(() {
      story.addEvent(type);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<StoryEvent> events = story.getEvents();
    bool duringSleep = false;

    return Column(
      children: [
        Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Timeline.tileBuilder(
                builder: TimelineTileBuilder.connected(
                  connectionDirection: ConnectionDirection.after,
                  contentsAlign: ContentsAlign.basic,
                  contentsBuilder: (context, index) => Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Text(events[index].getDescription())),
                  oppositeContentsBuilder: (context, index) => Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Text(events[index].getFormattedTime())),
                  // nodePositionBuilder: (context, index) => 0.4,
                  // indicatorPositionBuilder: (context, index) => 0.0,
                  connectorBuilder: (context, index, connectorType) {
                    if (events[index].getEventType() ==
                        EventType.ended_sleeping) {
                      duringSleep = true;
                    } else if (events[index].getEventType() ==
                        EventType.started_sleeping) {
                      duringSleep = false;
                    }
                    return SolidLineConnector(
                      thickness: 6,
                      space: 40,
                      color: duringSleep ? Colors.green : Colors.blue,
                    );
                  },
                  itemExtentBuilder: (context, index) {
                    const double base = 30;
                    print('$index ${events.length}');
                    if (index == events.length - 1) return base;

                    DateTime curTime = events[index].getLocalTime();
                    DateTime prevTime = events[index + 1].getLocalTime();
                    Duration diff = curTime.difference(prevTime);
                    return base + diff.inMinutes;
                  },
                  indicatorPositionBuilder: (context, index) => 0,
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
                      onPressed: () => _addEvent(story.isSleeping()
                          ? EventType.ended_sleeping
                          : EventType.started_sleeping),
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

class StoryData {
  List<StoryEvent> _events = [
    StoryEvent.withTime(
        EventType.diaper, DateTime.now().subtract(Duration(hours: 3))),
  ];
  bool _isSleeping = false;

  List<StoryEvent> getEvents() => _events;
  void addEvent(EventType type) {
    _events.insert(0, StoryEvent(type));
    if (type == EventType.started_sleeping) _isSleeping = true;
    if (type == EventType.ended_sleeping) _isSleeping = false;
  }

  bool isSleeping() => _isSleeping;
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
