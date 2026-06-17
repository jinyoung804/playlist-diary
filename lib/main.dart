import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Muelog',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(), // 여기가 HomeScreen이면 됩니다!
    );
  }
}