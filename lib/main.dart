import 'package:baby_binder/models/child_data.dart';
import 'package:baby_binder/screens/child_selection_page.dart';
import 'package:flutter/material.dart';
import 'screens/child_settings_page.dart';
import 'screens/child_story_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ChildData>(
      create: (context) => ChildData(id: 1),
      child: BabyBinder(),
    ),
  );
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
      initialRoute: ChildSelectionPage.routeName,
      routes: {
        ChildSelectionPage.routeName: (context) => ChildSelectionPage(),
        ChildSettingsPage.routeName: (context) => ChildSettingsPage(),
        ChildStoryPage.routeName: (context) => ChildStoryPage(),
      },
    );
  }
}
