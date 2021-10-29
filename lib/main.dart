import 'package:flutter/material.dart';
import 'screens/child_settings_page.dart';
import 'screens/child_story.dart';

void main() {
  runApp(BabyBinder());
}

class BabyBinder extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Binder',
      theme: ThemeData(
          colorScheme: ColorScheme.light().copyWith(
        primary: Colors.teal,
      )),
      initialRoute: ChildSettingsPage.routeName,
      routes: {
        ChildSettingsPage.routeName: (context) => ChildSettingsPage(),
        ChildStoryPage.routeName: (context) => ChildStoryPage(),
      },
    );
  }
}
