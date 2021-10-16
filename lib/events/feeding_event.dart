import 'dart:math';

import 'package:flutter/material.dart';
import 'story_events.dart';
import 'add_event_dialog.dart';
import '../constants.dart';

class NursingSideCard extends StatelessWidget {
  const NursingSideCard({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.teal,
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => {},
                icon: Icon(Icons.remove),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '10',
                    style: kLargeNumberTextStyle,
                  ),
                  Text('min'),
                ],
              ),
              IconButton(onPressed: () => {}, icon: Icon(Icons.add)),
            ],
          ),
        )
      ]),
      margin: EdgeInsets.all(10),
    );
  }
}

class NursingTab extends StatelessWidget {
  const NursingTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: NursingSideCard(
              text: 'Left',
            )),
            Expanded(
              child: NursingSideCard(text: 'Right'),
            )
          ],
        ),
      ),
    );
  }
}

const double minOz = .1;
const double maxOz = 10;
const double minML = 1;
const double maxML = 100;

class BottleTab extends StatelessWidget {
  const BottleTab(
      {Key? key, required this.eventData, required this.updateEventData})
      : super(key: key);
  final Map eventData;
  final Function updateEventData;

  @override
  Widget build(BuildContext context) {
    bool isOunces = eventData['isOunces'] ?? true;
    double volume = eventData['volume'] ?? 4;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$volume', style: kLargeNumberTextStyle),
            SizedBox(width: 20),
            ToggleButtons(
              isSelected: [isOunces, !isOunces],
              borderRadius: BorderRadius.circular(10),
              onPressed: (selected) {
                bool changingToOunces = selected == 0;
                if (changingToOunces != isOunces) {
                  double convertedVolume;
                  if (changingToOunces) {
                    convertedVolume = max(
                        double.parse((volume / 29.5735).toStringAsFixed(1)),
                        minOz);
                  } else {
                    convertedVolume =
                        min((volume * 29.5735).floorToDouble(), maxML);
                  }
                  updateEventData({
                    'isOunces': changingToOunces,
                    'volume': convertedVolume
                  });
                }
              },
              children: [Text('oz'), Text('mL')],
            ),
          ],
        ),
        Slider(
            value: volume,
            min: isOunces ? minOz : minML,
            max: isOunces ? maxOz : maxML,
            onChanged: (volume) => updateEventData({
                  'volume':
                      double.parse(volume.toStringAsFixed(isOunces ? 1 : 0))
                }))
      ],
    );
  }
}

class SolidTab extends StatelessWidget {
  const SolidTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Solids'));
  }
}

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
