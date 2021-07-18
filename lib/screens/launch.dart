import 'package:flutter/material.dart';

typedef void OnPressCallback();

class LaunchScreen extends StatelessWidget {
  static final String name = 'launch_screen';

  final OnPressCallback onPressed;

  LaunchScreen(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black,
      child: Center(
        child: OutlinedButton(
          child: Text('PLAY'),
          onPressed: this.onPressed,
        ),
      ),
    );
  }
}
