import 'package:flutter/material.dart';

class ChildSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget avatar = Expanded(
      flex: 1,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(
                'images/baby.jpg',
              ),
              radius: 75.0,
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 18),
              child: Text(
                'Elliott',
                style: TextStyle(fontSize: 20, color: Colors.grey[600]),
              ),
            )
          ],
        ),
      ),
    );

    Container _buildSettingRow(String name, String value) {
      const double fontSize = 18;

      return Container(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ));
    }

    Widget settingsSection = Expanded(
        flex: 1,
        child: Column(children: [
          _buildSettingRow('setting name', 'value'),
          _buildSettingRow('setting name 2', 'value 2')
        ]));

    void _goToStory() {}
    Widget buttonSection = Container(
        alignment: Alignment.center,
        child: OutlinedButton(
          child: Container(
              padding: EdgeInsets.all(8),
              child: Text(
                'View Story',
                style: TextStyle(fontSize: 20),
              )),
          onPressed: _goToStory,
        ));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          avatar,
          settingsSection,
          buttonSection,
        ],
      ),
    );
  }
}
