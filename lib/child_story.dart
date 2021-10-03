import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'dart:math';
import 'story_events.dart';

class EventButton extends StatelessWidget {
  const EventButton({
    Key? key,
    required this.size,
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
  }) : super(key: key);
  final double size;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      fillColor: backgroundColor,
      onPressed: () {
        // onPressed();
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('AlertDialog Title'),
                  content: const Text('AlertDialog description'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ));
      },
      child: Icon(
        icon,
        size: size / 1.5,
        color: iconColor,
      ),
    );
  }
}

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

  bool clicked = false;

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
        AddEventButtons(isSleeping: story.isSleeping(), addEvent: _addEvent),
      ],
    );
  }
}

class AddEventButtons extends StatefulWidget {
  const AddEventButtons(
      {Key? key, required this.isSleeping, required this.addEvent})
      : super(key: key);
  final bool isSleeping;
  final Function addEvent;

  @override
  _AddEventButtonsState createState() => _AddEventButtonsState();
}

class _AddEventButtonsState extends State<AddEventButtons> {
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Material(
        color: Colors.teal[300],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: [
              EventButton(
                size: 75,
                backgroundColor: EventType.ended_sleeping.backgroundColor,
                icon: EventType.ended_sleeping.icon,
                iconColor: EventType.ended_sleeping.iconColor,
                onPressed: () => widget.addEvent(widget.isSleeping
                    ? EventType.ended_sleeping
                    : EventType.started_sleeping),
              ),
              EventButton(
                size: 75,
                backgroundColor: EventType.diaper.backgroundColor,
                icon: EventType.diaper.icon,
                iconColor: EventType.diaper.iconColor,
                onPressed: () {
                  setState(() {
                    widget.addEvent(EventType.diaper);
                    clicked = true;
                  });
                },
              ),
              EventButton(
                size: 75,
                backgroundColor: EventType.feeding.backgroundColor,
                icon: EventType.feeding.icon,
                iconColor: EventType.feeding.iconColor,
                onPressed: () => widget.addEvent(EventType.feeding),
              ),
            ],
          ),
        ),
      ),
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
