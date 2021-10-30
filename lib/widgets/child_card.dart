import 'package:baby_binder/screens/child_settings_page.dart';
import 'package:baby_binder/screens/child_story_page.dart';
import 'package:flutter/material.dart';
import 'child_avatar.dart';

class ChildCard extends StatelessWidget {
  const ChildCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: ChildAvatar(
              maxRadius: MediaQuery.of(context).size.width / 3,
            )),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, ChildStoryPage.routeName),
              child: Text('View Story'),
            ),
            OutlinedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, ChildSettingsPage.routeName),
              child: Text('Settings'),
            )
          ],
        ),
      ),
    );
  }
}
