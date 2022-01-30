import 'package:baby_binder/events/feeding/feeding_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';

// const String kFruitsGroup = 'fruit';
// const String kVegetablesGroup = 'vegetable';
// const String kMeatsGroup = 'meat';

const topThree = <String>[
  'Blueberries',
  'Bread',
  'Candy',
];
const mockResults = <String>[
  'Bread',
  'Cheese',
  'Apple',
  'Orange',
  'Chicken Nuggets',
  'Pancake',
  'Egg',
  'Blueberries'
];

class SolidTab extends StatefulWidget {
  SolidTab({
    Key? key,
    required this.event,
    required this.updateEventData,
  }) : super(key: key);

  final FeedingEvent event;
  final Function(Function()) updateEventData;

  @override
  State<SolidTab> createState() => _SolidTabState();
}

class _SolidTabState extends State<SolidTab> {
  final _chipKey = GlobalKey<ChipsInputState>();
  List<String> filteredTop = topThree;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChipsInput(
          key: _chipKey,
          decoration: InputDecoration(
            labelText: "Select Foods",
          ),
          maxChips: 3,
          findSuggestions: (String query) {
            if (query.length != 0) {
              var lowercaseQuery = query.toLowerCase();
              return mockResults.where((food) {
                return food.toLowerCase().contains(query.toLowerCase());
              }).toList(growable: false)
                ..sort((a, b) => a
                    .toLowerCase()
                    .indexOf(lowercaseQuery)
                    .compareTo(b.toLowerCase().indexOf(lowercaseQuery)));
            } else {
              return const <String>[];
            }
          },
          onChanged: (List<String> data) {
            setState(() {
              widget.updateEventData(() => widget.event.solidFoods = data);
              filteredTop =
                  topThree.where((food) => !data.contains(food)).toList();
            });
          },
          chipBuilder: (context, state, String food) {
            return InputChip(
              key: ObjectKey(food),
              label: Text(food),
              onDeleted: () => state.deleteChip(food),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          },
          suggestionBuilder: (context, state, String food) {
            return ListTile(
              key: ObjectKey(food),
              title: Text(food),
              // subtitle: Text(food.category),
              onTap: () => state.selectSuggestion(food),
            );
          },
        ),
        Wrap(
          children: List<Widget>.from(filteredTop.map((food) => ElevatedButton(
              onPressed: () {
                _chipKey.currentState!.selectSuggestion(food);
              },
              child: Text(food)))),
        )
      ],
    );
  }
}
