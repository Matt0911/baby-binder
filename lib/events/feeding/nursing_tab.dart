import 'package:baby_binder/constants.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'feeding_event.dart';

class NursingSideCard extends StatelessWidget {
  const NursingSideCard({
    Key? key,
    required this.text,
    required this.time,
    required this.updateValue,
  }) : super(key: key);
  final String text;
  final int time;
  final Function(int) updateValue;

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
                onPressed: () => updateValue(-1),
                icon: Icon(Icons.remove),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    time.toString(),
                    style: kLargeNumberTextStyle,
                  ),
                  Text('min'),
                ],
              ),
              IconButton(
                onPressed: () => updateValue(1),
                icon: Icon(Icons.add),
              ),
            ],
          ),
        )
      ]),
      margin: EdgeInsets.all(10),
    );
  }
}

class NursingTab extends StatelessWidget {
  const NursingTab({
    Key? key,
    required this.event,
    required this.updateEventData,
  }) : super(key: key);
  final FeedingEvent event;
  final Function(Function()) updateEventData;

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
                time: event.leftTime,
                updateValue: (delta) => updateEventData(
                  () => event.leftTime = (event.leftTime + delta).clamp(0, 60),
                ),
              ),
            ),
            Expanded(
              child: NursingSideCard(
                text: 'Right',
                time: event.rightTime,
                updateValue: (delta) => updateEventData(
                  () =>
                      event.rightTime = (event.rightTime + delta).clamp(0, 60),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
