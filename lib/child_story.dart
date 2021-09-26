import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

class ChildStory extends StatelessWidget {
  const ChildStory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
              flex: 3,
              child: Timeline.tileBuilder(
                builder: TimelineTileBuilder.fromStyle(
                  contentsAlign: ContentsAlign.alternating,
                  contentsBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text('Timeline Event $index'),
                  ),
                  itemCount: 10,
                ),
              )),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              // color: Colors.teal[50],
              child: Material(
                color: Colors.transparent,
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 15,
                  padding: EdgeInsets.all(8.0),
                  children: [
                    Ink(
                      decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        color: Colors.blue[50],
                      ),
                      child: IconButton(
                          color: Colors.green,
                          onPressed: () => print('hi'),
                          icon: Icon(Icons.check)),
                    ),
                    Ink(
                      decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        color: Colors.red[50],
                      ),
                      child: IconButton(
                          color: Colors.red,
                          onPressed: () => print('hi'),
                          icon: Icon(Icons.baby_changing_station)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
