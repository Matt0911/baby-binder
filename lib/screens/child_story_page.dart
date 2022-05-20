import 'package:baby_binder/events/story_events.dart';
import 'package:baby_binder/providers/app_state.dart';
import 'package:baby_binder/providers/children_data.dart';
import 'package:baby_binder/providers/hive_provider.dart';
import 'package:baby_binder/providers/story_data.dart';
import 'package:baby_binder/screens/labor_tracker_page.dart';
import 'package:baby_binder/widgets/baby_binder_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timelines/timelines.dart';
import 'dart:math';

class ChildStoryPage extends ConsumerWidget {
  static final routeName = '/child-story';

  const ChildStoryPage({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    Child? activeChild = ref.watch(activeChildProvider);
    return activeChild == null
        ? const CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(title: Text('${activeChild.name}\'s Story')),
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
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      constraints: BoxConstraints(minHeight: 50, maxHeight: 50),
                      child: Center(
                        widthFactor: 1,
                        child: Text(
                          events[index].getTimelineDescription(),
                          style: TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  oppositeContentsBuilder: (context, index) => Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      constraints: BoxConstraints(minHeight: 50, maxHeight: 50),
                      child: Center(
                        widthFactor: 1,
                        child: Text(
                          events[index].getFormattedTime(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
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
                    const double base = 60;
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
                    return GestureDetector(
                      onLongPress: () =>
                          story.editEvent(events[index], context),
                      child: DotIndicator(
                        color: type.iconColor,
                        size: 50,
                        child: Icon(
                          type.icon,
                          color: type.backgroundColor,
                          size: 30,
                        ),
                      ),
                    );
                  },
                  itemCount: events.length,
                ),
              ),
            )),
        AddEventButtons(addEvent: story.addNewEvent),
      ],
    );
  }
}

class AddEventButtons extends ConsumerStatefulWidget {
  const AddEventButtons({Key? key, required this.addEvent}) : super(key: key);
  final Function(EventType, BuildContext) addEvent;

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
          onPressed: () => widget.addEvent(
            story.isSleeping
                ? EventType.ended_sleeping
                : EventType.started_sleeping,
            context,
          ),
        ),
        EventButton(
          size: 60,
          backgroundColor: EventType.diaper.backgroundColor,
          icon: EventType.diaper.icon,
          iconColor: EventType.diaper.iconColor,
          onPressed: () {
            setState(() {
              widget.addEvent(EventType.diaper, context);
              clicked = true;
            });
          },
        ),
        EventButton(
          size: 60,
          backgroundColor: EventType.feeding.backgroundColor,
          icon: EventType.feeding.icon,
          iconColor: EventType.feeding.iconColor,
          onPressed: () => widget.addEvent(EventType.feeding, context),
        ),
      ];

  List<Widget> getUnbornEvents(BuildContext context) => [
        EventButton(
          size: 60,
          backgroundColor: Colors.orange.shade50,
          icon: Icons.medical_services,
          iconColor: Colors.orange,
          onPressed: () => ref
              .read(appStateProvider)
              .navigateToPage(context, LaborTrackerPage.routeName),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final activeChild = ref.watch(activeChildProvider);
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
