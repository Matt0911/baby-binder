import 'package:baby_binder/providers/children_data.dart';
import 'package:baby_binder/widgets/baby_binder_drawer.dart';
import 'package:baby_binder/widgets/child_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChildSettingsPage extends ConsumerWidget {
  static final String routeName = '/child-settings-page';

  @override
  Widget build(context, ref) {
    final activeChild = ref.watch(activeChildProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baby Binder'),
      ),
      drawer: BabyBinderDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ChildAvatar(
                childImage: activeChild!.image,
                childName: activeChild.name,
                updateName: activeChild.updateName,
              ),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  children: [
                    DateSettingRow(
                      settingName: 'Birth Date',
                      settingValue: activeChild.birthdate,
                      updateValue: activeChild.updateBirthDate,
                    ),
                    activeChild.birthdate != null &&
                            DateTime(
                                  activeChild.birthdate!.year,
                                  activeChild.birthdate!.month,
                                  activeChild.birthdate!.day,
                                ).compareTo(DateTime.now()) <=
                                0
                        ? TimeSettingRow(
                            settingName: 'Birth Time',
                            settingValue: activeChild.birthdate!,
                            updateValue: activeChild.updateBirthDate,
                          )
                        : SizedBox(),
                  ],
                )),
            // OutlinedButton(
            //   child: Text(
            //     'View Story',
            //     style: TextStyle(fontSize: 20),
            //   ),
            //   onPressed: () =>
            //       Navigator.pushNamed(context, ChildStoryPage.routeName),
            // ),
          ],
        ),
      ),
    );
  }
}

final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
final DateFormat _timeFormatter = DateFormat('hh:mm a');

class DateSettingRow extends StatelessWidget {
  const DateSettingRow({
    Key? key,
    this.fontSize = 18,
    required this.settingName,
    required this.settingValue,
    required this.updateValue,
  }) : super(key: key);

  final double fontSize;
  final String settingName;
  final DateTime? settingValue;
  final Function(DateTime?) updateValue;

  @override
  Widget build(context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            settingName,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        MaterialButton(
          visualDensity: VisualDensity.compact,
          onPressed: () async {
            DateTime now = DateTime.now();
            final selected = await showDatePicker(
              context: context,
              initialDate: now,
              firstDate: DateTime.utc(2000),
              lastDate: now.add(Duration(days: 280)),
            );
            if (selected == null) return;
            updateValue(selected);
          },
          child: Text(
            settingValue == null ? 'Set' : _dateFormatter.format(settingValue!),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}

class TimeSettingRow extends StatelessWidget {
  const TimeSettingRow({
    Key? key,
    this.fontSize = 18,
    required this.settingName,
    required this.settingValue,
    required this.updateValue,
  }) : super(key: key);

  final double fontSize;
  final String settingName;
  final DateTime settingValue;
  final Function(DateTime?) updateValue;

  @override
  Widget build(context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            settingName,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        MaterialButton(
          visualDensity: VisualDensity.compact,
          onPressed: () async {
            final selected = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(settingValue),
            );
            print('selected $selected');
            if (selected == null) return;
            updateValue(new DateTime(settingValue.year, settingValue.month,
                settingValue.day, selected.hour, selected.minute));
          },
          child: Text(
            _timeFormatter.format(settingValue),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}

class SettingRow extends StatelessWidget {
  const SettingRow({
    Key? key,
    required this.fontSize,
    required this.settingName,
    required this.settingValue,
  }) : super(key: key);

  final double fontSize;
  final String settingName;
  final String settingValue;

  @override
  Widget build(context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text(
                settingName,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              child: Text(
                settingValue,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ));
  }
}
