import 'package:flutter/material.dart';

import '../constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen(
      {Key? key,
      required this.onFinished,
      required this.splashMaxDurationInSec})
      : super(key: key);
  final Function onFinished;
  final int splashMaxDurationInSec;

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: splashMaxDurationInSec),
      () => onFinished(),
    );

    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: const Text(
          'Baby Binder',
          style: kTitleDarkTextStyle,
        ),
      ),
    );
  }
}
