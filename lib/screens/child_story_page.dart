import 'package:baby_binder/models/child_data.dart';
import 'package:baby_binder/models/story_data.dart';
import 'package:baby_binder/widgets/baby_binder_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import 'dart:math';
import '../events/story_events.dart';
import '../events/sleep_events.dart';
import '../events/diaper_event.dart';
import '../events/feeding/feeding_event.dart';

class ChildStoryPage extends StatelessWidget {
  static final routeName = '/child-story';

  const ChildStoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ChildData, String>(
      selector: (_, childData) => childData.activeChild!.name,
      builder: (_, name, __) => Scaffold(
        appBar: AppBar(title: Text('$name\'s Story')),
        drawer: BabyBinderDrawer(),
        body: Selector<ChildData, StoryData>(
            selector: (_, childData) => childData.activeChild!.story,
            builder: (_, story, __) => ChildStory(story: story)),
      ),
    );
  }
}

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
      constraints: BoxConstraints(minWidth: size + 8, minHeight: size + 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      fillColor: backgroundColor,
      onPressed: () => onPressed(),
      child: Icon(
        icon,
        size: size / 1.5,
        color: iconColor,
      ),
    );
  }
}

class ChildStory extends StatefulWidget {
  const ChildStory({Key? key, required this.story}) : super(key: key);

  final StoryData story;

  @override
  _ChildStoryState createState() => _ChildStoryState();
}

class _ChildStoryState extends State<ChildStory> {
  void _addEvent(StoryEvent event) async {
    if (event.requiresDialog) {
      List results = await showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        context: context,
        builder: (BuildContext context) => SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10)
                .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: event.buildAddDialog!(context),
            ),
          ),
        ),
      );
      bool didSave = results[0];
      if (didSave) {
        setState(() {
          print('data from dialog: ${results[1]}');
          widget.story.addEvent(event);
        });
      } else {
        print('user cancelled');
      }
    } else {
      setState(() {
        widget.story.addEvent(event);
      });
    }
  }

  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    List<StoryEvent> events = widget.story.getEvents();
    bool duringSleep = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Timeline.tileBuilder(
                builder: TimelineTileBuilder.connected(
                  connectionDirection: ConnectionDirection.after,
                  contentsAlign: ContentsAlign.basic,
                  contentsBuilder: (context, index) => Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(events[index].description)),
                  oppositeContentsBuilder: (context, index) => Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Text(events[index].getFormattedTime())),
                  // nodePositionBuilder: (context, index) => 0.4,
                  // indicatorPositionBuilder: (context, index) => 0.0,
                  connectorBuilder: (context, index, connectorType) {
                    if (events[index].eventType == EventType.ended_sleeping) {
                      duringSleep = true;
                    } else if (events[index].eventType ==
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
                    EventType type = events[index].eventType;
                    return DotIndicator(
                      color: type.iconColor,
                    );
                  },
                  itemCount: events.length,
                ),
              ),
            )),
        AddEventButtons(
            isSleeping: widget.story.isSleeping(), addEvent: _addEvent),
      ],
    );
  }
}

class AddEventButtons extends StatefulWidget {
  const AddEventButtons(
      {Key? key, required this.isSleeping, required this.addEvent})
      : super(key: key);
  final bool isSleeping;
  final Function(StoryEvent) addEvent;

  @override
  _AddEventButtonsState createState() => _AddEventButtonsState();
}

class _AddEventButtonsState extends State<AddEventButtons> {
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return Material(
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
              size: 60,
              backgroundColor: EventType.ended_sleeping.backgroundColor,
              icon: EventType.ended_sleeping.icon,
              iconColor: EventType.ended_sleeping.iconColor,
              onPressed: () => widget.addEvent(
                  widget.isSleeping ? EndSleepEvent() : StartSleepEvent()),
            ),
            EventButton(
              size: 60,
              backgroundColor: EventType.diaper.backgroundColor,
              icon: EventType.diaper.icon,
              iconColor: EventType.diaper.iconColor,
              onPressed: () {
                setState(() {
                  widget.addEvent(DiaperEvent());
                  clicked = true;
                });
              },
            ),
            EventButton(
              size: 60,
              backgroundColor: EventType.feeding.backgroundColor,
              icon: EventType.feeding.icon,
              iconColor: EventType.feeding.iconColor,
              onPressed: () => widget.addEvent(FeedingEvent()),
            ),
          ],
        ),
      ),
    );
  }
}
