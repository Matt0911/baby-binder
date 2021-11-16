import 'package:flutter/material.dart';

import '../constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen(
      {Key? key, required this.onFinished, required this.splashDurationInSec})
      : super(key: key);
  final Function onFinished;
  final int splashDurationInSec;

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: splashDurationInSec),
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
