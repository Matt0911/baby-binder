import 'dart:async';

import 'package:baby_binder/constants.dart';
import 'package:baby_binder/providers/children_data.dart';
import 'package:baby_binder/providers/labor_tracker.dart';
import 'package:baby_binder/widgets/baby_binder_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wakelock/wakelock.dart';
import 'package:timelines/timelines.dart';
import 'dart:math';

String convertSecsToString(int valueInSecs) {
  final mins = valueInSecs ~/ 60;
  final secs = valueInSecs % 60;
  return '${mins > 0 ? '${mins}m ' : ''}${secs > 0 ? '${secs}s' : ''}';
}

class OneHourAveragesDisplay extends ConsumerWidget {
  const OneHourAveragesDisplay({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final oneHourData = ref.watch(oneHourLaborDataProvider);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 10),
        Text('Last Hour Averages',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            )),
        SizedBox(height: 10),
        Expanded(
          child: Row(
            children: [
              SizedBox(width: 10),
              OneHourAverage(
                  title: 'Duration', valueInSec: oneHourData.durationSeconds),
              SizedBox(width: 20),
              OneHourAverage(
                  title: 'Interval', valueInSec: oneHourData.intervalSeconds),
              SizedBox(width: 10),
            ],
          ),
        )
      ],
    );
  }
}

class OneHourAverage extends StatelessWidget {
  OneHourAverage({
    Key? key,
    required this.title,
    required this.valueInSec,
  }) : super(key: key);

  final String title;
  final int valueInSec;

  @override
  Widget build(BuildContext context) {
    String value = valueInSec > 0 ? convertSecsToString(valueInSec) : '--';
    return Expanded(
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: kMedNumberTextStyle,
            ),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

final DateFormat _formatter = DateFormat('EEE MMM d hh:mma');

class DataRow extends StatelessWidget {
  const DataRow({Key? key, required this.items, this.isBold = false})
      : super(key: key);
  final List<String?> items;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items
            .map((text) => Expanded(
                  child: Center(
                    child: text != null
                        ? Text(
                            text,
                            style: isBold
                                ? kDataRowBoldTextStyle
                                : kDataRowTextStyle,
                          )
                        : const SizedBox(),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class ContractionRow extends StatelessWidget {
  const ContractionRow(
      {Key? key, required this.contraction, this.prevContraction})
      : super(key: key);
  final Contraction contraction;
  final Contraction? prevContraction;

  @override
  Widget build(BuildContext context) {
    return DataRow(items: [
      _formatter.format(contraction.start),
      contraction.duration != null
          ? convertSecsToString(contraction.duration!.inSeconds)
          : null,
      prevContraction == null
          ? '--'
          : convertSecsToString(
              contraction.start.difference(prevContraction!.start).inSeconds),
    ]);
  }
}

class TitleRow extends StatelessWidget {
  const TitleRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataRow(items: ['Time', 'Duration', 'Interval'], isBold: true);
  }
}

class ContractionTimerButton extends StatefulWidget {
  const ContractionTimerButton(
      {Key? key, required this.stopwatch, required this.isRunning})
      : super(key: key);
  final Stopwatch stopwatch;
  final bool isRunning;

  @override
  _ContractionTimerButtonState createState() => _ContractionTimerButtonState();
}

class _ContractionTimerButtonState extends State<ContractionTimerButton> {
  Timer? _timer;
  String _label = '0s';

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (widget.isRunning) {
          setState(() {
            _label = '${widget.stopwatch.elapsed.inSeconds}s';
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isRunning && (_timer == null || !_timer!.isActive)) {
      startTimer();
    } else if (!widget.isRunning) {
      _timer?.cancel();
      _label = '0s';
    }
    return Text(widget.isRunning ? _label : 'Start');
  }
}

class LaborTrackerPage extends ConsumerStatefulWidget {
  static final routeName = '/labor-tracker';

  LaborTrackerPage({Key? key}) : super(key: key);

  final Stopwatch stopwatch = Stopwatch();

  @override
  LaborTrackerPageState createState() => LaborTrackerPageState();
}

class LaborTrackerPageState extends ConsumerState<LaborTrackerPage> {
  Contraction? currentContraction;

  @override
  Widget build(BuildContext context) {
    final activeChild = ref.watch(activeChildProvider);
    final laborData = ref.watch(laborTrackerDataProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Labor Tracker')),
      drawer: BabyBinderDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Expanded(
          //     flex: 2,
          //     child: Container(
          //       color: Colors.blue,
          //     )),
          Expanded(
            flex: 1,
            child: OneHourAveragesDisplay(),
          ),
          TitleRow(),
          Expanded(
            flex: 4,
            child: ListView.builder(
              itemCount: laborData.contractions.length,
              itemBuilder: (context, i) => ContractionRow(
                contraction: laborData.contractions[i],
                prevContraction: i + 1 < laborData.contractions.length
                    ? laborData.contractions[i + 1]
                    : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RawMaterialButton(
              onPressed: () {
                setState(() {
                  if (currentContraction == null) {
                    currentContraction = Contraction();
                    widget.stopwatch.start();
                    Wakelock.enable();
                  } else {
                    widget.stopwatch.stop();
                    Wakelock.disable();
                    currentContraction!.duration = widget.stopwatch.elapsed;
                    laborData.addNewContraction(currentContraction!);
                    widget.stopwatch.reset();
                    currentContraction = null;
                  }
                });
              },
              child: ContractionTimerButton(
                stopwatch: widget.stopwatch,
                isRunning: currentContraction != null,
              ),
              fillColor: currentContraction == null ? Colors.green : Colors.red,
              constraints: BoxConstraints(minHeight: 60),
              textStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
