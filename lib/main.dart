import 'package:flutter/material.dart';
import './ui/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biometric',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.red, backgroundColor: Colors.white),
      home: SplashScreen(),
    );
  }
}
