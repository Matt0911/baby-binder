import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:intl/intl.dart';
import 'dart:math';

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

  Widget _buildEventButton(
      {backgroundColor: Color,
      icon: Icon,
      iconColor: Color,
      onPressed: Function}) {
    return SizedBox(
      child: Ink(
        width: 75,
        height: 75,
        decoration: ShapeDecoration(
          shape: CircleBorder(),
          color: backgroundColor,
        ),
        child: IconButton(
            color: iconColor,
            onPressed: onPressed,
            icon: Icon(
              icon,
              size: 48,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<StoryEvent> events = story.getEvents();
    bool duringSleep = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      alignment: AlignmentDirectional.topStart,
                      child: Text(events[index].getDescription())),
                  oppositeContentsBuilder: (context, index) => Align(
                      alignment: AlignmentDirectional.topEnd,
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
                    if (index == events.length - 1) return base;

                    DateTime curTime = events[index].getLocalTime();
                    DateTime prevTime = events[index + 1].getLocalTime();
                    int diff = curTime.difference(prevTime).inMinutes;
                    double scaled = min((diff == 0 ? 1 : diff) / 2, 250);
                    return base + scaled;
                  },
                  indicatorPositionBuilder: (context, index) => 0,
                  indicatorBuilder: (context, index) {
                    EventType type = events[index].getEventType();
                    return DotIndicator(
                      color: type.iconColor,
                    );
                  },
                  itemCount: events.length,
                ),
              ),
            )),
        // Divider(
        //   color: Colors.teal[200],
        //   thickness: 3,
        //   height: 3,
        // ),
        Material(
          color: Colors.teal[300],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildEventButton(
                  backgroundColor: Colors.green[50],
                  icon: Icons.crib,
                  iconColor: Colors.green,
                  onPressed: () => _addEvent(story.isSleeping()
                      ? EventType.ended_sleeping
                      : EventType.started_sleeping),
                ),
                _buildEventButton(
                  backgroundColor: Colors.red[50],
                  icon: Icons.baby_changing_station,
                  iconColor: Colors.red,
                  onPressed: () => _addEvent(EventType.diaper),
                ),
                _buildEventButton(
                  backgroundColor: Colors.orange[50],
                  icon: Icons.restaurant,
                  iconColor: Colors.orange,
                  onPressed: () => _addEvent(EventType.feeding),
                ),
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
    StoryEvent.withTime(EventType.started_sleeping,
        DateTime.now().subtract(Duration(hours: 3))),
  ];
  bool _isSleeping = true;

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
  feeding,
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
      case EventType.feeding:
        return 'Ate';
      default:
        return '';
    }
  }

  Color get iconColor {
    switch (this) {
      case EventType.diaper:
        return Colors.red;
      case EventType.started_sleeping:
        return Colors.green;
      case EventType.ended_sleeping:
        return Colors.green;
      case EventType.feeding:
        return Colors.orange;
      default:
        return Colors.transparent;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case EventType.diaper:
        return Colors.red.shade50;
      case EventType.started_sleeping:
        return Colors.green.shade50;
      case EventType.ended_sleeping:
        return Colors.green.shade50;
      case EventType.feeding:
        return Colors.orange.shade50;
      default:
        return Colors.transparent;
    }
  }

  IconData get icon {
    switch (this) {
      case EventType.diaper:
        return Icons.baby_changing_station;
      case EventType.started_sleeping:
        return Icons.crib;
      case EventType.ended_sleeping:
        return Icons.crib;
      case EventType.feeding:
        return Icons.restaurant;
      default:
        return Icons.close;
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
