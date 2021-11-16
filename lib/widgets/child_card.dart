import 'package:baby_binder/models/child_data.dart';
import 'package:baby_binder/screens/child_settings_page.dart';
import 'package:baby_binder/screens/child_story_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'child_avatar.dart';

class ChildCard extends StatelessWidget {
  const ChildCard({Key? key, required this.childData}) : super(key: key);
  final Child childData;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: ChildAvatar(
              imageUrl: childData.image,
              name: childData.name,
              maxRadius: MediaQuery.of(context).size.width / 3,
            )),
            ElevatedButton(
              onPressed: () {
                context.read<ChildData>().changeChild(id: childData.id);
                Navigator.pushNamed(context, ChildStoryPage.routeName);
              },
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
