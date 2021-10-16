import 'package:flutter/material.dart';
import 'child_settings_page.dart';
import 'child_story.dart';

void main() {
  runApp(BabyBinder());
}

class BabyBinder extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData(
      primarySwatch: Colors.teal,
    );

    void _openMenu() {}

    return MaterialApp(
      title: 'Baby Binder',
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            padding: const EdgeInsets.all(0),
            alignment: Alignment.center,
            icon: Icon(Icons.menu),
            // color: Colors.red[500],
            onPressed: _openMenu,
            // enableFeedback: false,
          ),
          title: const Text('Baby Binder'),
        ),
        // body: ChildSettingsPage(),
        body: ChildStory(),
      ),
    );
  }
}
