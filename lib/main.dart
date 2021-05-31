import 'package:flutter/material.dart';
import 'home.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Loading is done, return the app:
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'MachineTest',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'MachineTest Demo App'),
      );
    });
  }
}
