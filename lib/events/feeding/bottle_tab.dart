import 'dart:math';

import 'package:flutter/material.dart';

import '../../constants.dart';

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
