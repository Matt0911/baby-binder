import 'package:baby_binder/constants.dart';
import 'package:baby_binder/providers/auth_state.dart';
import 'package:baby_binder/providers/children_data.dart';
import 'package:baby_binder/screens/child_selection_page.dart';
import 'package:baby_binder/screens/child_settings_page.dart';
import 'package:baby_binder/screens/child_story_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'child_avatar.dart';

class BabyBinderDrawer extends ConsumerWidget {
  const BabyBinderDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(context, ref) {
    String currentRoute = ModalRoute.of(context)!.settings.name ?? 'test';
    final activeChild = ref.watch(childrenDataProvider).activeChild;
    final authState = ref.watch(authStateProvider);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                ChildAvatar(
                  imageUrl: activeChild!.image,
                  name: activeChild.name,
                  maxRadius: 25,
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pushNamed(
                      context, ChildSelectionPage.routeName),
                  icon: Icon(
                    Icons.switch_account_outlined,
                    size: 16,
                    color: kGreyTextColor,
                  ),
                  label: Text(
                    'Change',
                    style: TextStyle(fontSize: 12, color: kGreyTextColor),
                  ),
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Story'),
            selected: ChildStoryPage.routeName == currentRoute,
            onTap: ChildStoryPage.routeName == currentRoute
                ? () => Navigator.pop(context)
                : () => Navigator.pushNamed(context, ChildStoryPage.routeName),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Child Settings'),
            selected: ChildSettingsPage.routeName == currentRoute,
            onTap: ChildSettingsPage.routeName == currentRoute
                ? () => Navigator.pop(context)
                : () =>
                    Navigator.pushNamed(context, ChildSettingsPage.routeName),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            selected: false,
            onTap: () => authState.signOut(context),
          ),
        ],
      ),
    );
  }
}
