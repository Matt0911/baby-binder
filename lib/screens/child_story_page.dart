import 'package:baby_binder/providers/children_data.dart';
import 'package:baby_binder/providers/story_data.dart';
import 'package:baby_binder/screens/labor_tracker_page.dart';
import 'package:baby_binder/widgets/baby_binder_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timelines/timelines.dart';
import 'dart:math';
import '../events/story_events.dart';
import '../events/sleep_events.dart';
import '../events/diaper_event.dart';
import '../events/feeding/feeding_event.dart';

class ChildStoryPage extends ConsumerWidget {
  static final routeName = '/child-story';

  const ChildStoryPage({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final childdata = ref.watch(childrenDataProvider);
    Child? activeChild = childdata.activeChild;
    return Scaffold(
      appBar: AppBar(title: Text('${activeChild!.name}\'s Story')),
      drawer: BabyBinderDrawer(),
      body: ChildStory(),
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

class ChildStory extends ConsumerWidget {
  ChildStory({
    Key? key,
  }) : super(key: key);

  void _addEvent(
    BuildContext context,
    StoryEvent event,
    StoryData story,
  ) async {
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
        story.addEvent(event);
      } else {
        print('user cancelled');
      }
    } else {
      story.addEvent(event);
    }
  }

  @override
  Widget build(context, ref) {
    bool duringSleep = false;
    final story = ref.watch(storyDataProvider);
    final events = story.events;

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
                    double scaled = min((diff <= 0 ? 1 : diff) / 2, 250);
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
        AddEventButtons(addEvent: _addEvent),
      ],
    );
  }
}

class AddEventButtons extends ConsumerStatefulWidget {
  const AddEventButtons({Key? key, required this.addEvent}) : super(key: key);
  final Function(BuildContext, StoryEvent, StoryData) addEvent;

  @override
  _AddEventButtonsState createState() => _AddEventButtonsState();
}

class _AddEventButtonsState extends ConsumerState<AddEventButtons> {
  bool clicked = false;
  List<Widget> getBornEvents(BuildContext context, StoryData story) => [
        EventButton(
          size: 60,
          backgroundColor: EventType.ended_sleeping.backgroundColor,
          icon: EventType.ended_sleeping.icon,
          iconColor: EventType.ended_sleeping.iconColor,
          onPressed: () => widget.addEvent(context,
              story.isSleeping ? EndSleepEvent() : StartSleepEvent(), story),
        ),
        EventButton(
          size: 60,
          backgroundColor: EventType.diaper.backgroundColor,
          icon: EventType.diaper.icon,
          iconColor: EventType.diaper.iconColor,
          onPressed: () {
            setState(() {
              widget.addEvent(context, DiaperEvent(), story);
              clicked = true;
            });
          },
        ),
        EventButton(
          size: 60,
          backgroundColor: EventType.feeding.backgroundColor,
          icon: EventType.feeding.icon,
          iconColor: EventType.feeding.iconColor,
          onPressed: () => widget.addEvent(context, FeedingEvent(), story),
        ),
      ];

  List<Widget> getUnbornEvents(BuildContext context) => [
        EventButton(
          size: 60,
          backgroundColor: Colors.orange.shade50,
          icon: Icons.medical_services,
          iconColor: Colors.orange,
          onPressed: () =>
              Navigator.of(context).pushNamed(LaborTrackerPage.routeName),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final activeChild = ref.watch(childrenDataProvider).activeChild;
    final story = ref.watch(storyDataProvider);
    return Material(
      color: Colors.teal[300],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 20,
          runSpacing: 20,
          children: activeChild!.isBorn
              ? getBornEvents(context, story)
              : getUnbornEvents(context),
        ),
      ),
    );
  }
}
