import 'package:flutter/material.dart';

import '../../constants.dart';

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
