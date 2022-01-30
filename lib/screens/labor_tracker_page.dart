import 'dart:async';

import 'package:baby_binder/constants.dart';
import 'package:baby_binder/providers/children_data.dart';
import 'package:baby_binder/providers/labor_tracker.dart';
import 'package:baby_binder/widgets/baby_binder_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timelines/timelines.dart';
import 'dart:math';

class AveragesDisplay extends StatelessWidget {
  const AveragesDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('1 Hour Averages',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Duration'),
            Text('Interval'),
            Text('Rest'),
          ],
        )
      ],
    );
  }
}

class ContractionRow extends StatelessWidget {
  const ContractionRow({Key? key, required this.contraction}) : super(key: key);
  final Contraction contraction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(contraction.start.toString()),
        contraction.duration != null
            ? Text('${contraction.duration!.inSeconds}s')
            : const SizedBox(),
      ],
    );
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
          Expanded(
              flex: 2,
              child: Container(
                color: Colors.blue,
              )),
          Expanded(
            flex: 2,
            child: AveragesDisplay(),
          ),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: laborData.contractions.length,
              itemBuilder: (context, i) => ContractionRow(
                contraction: laborData.contractions[i],
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
                  } else {
                    widget.stopwatch.stop();
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
