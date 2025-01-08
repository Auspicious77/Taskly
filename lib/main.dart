import 'package:flutter/material.dart';
import './pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  //Create database
  await Hive.initFlutter("hive_boxes");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 20, 76)),
        useMaterial3: true, // You can toggle this to false if needed
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 0, 20, 76), // Fix AppBar color
          foregroundColor: Colors.white, // Fix text/icon color
        ),
      ),
      home: const HomePage(),
    );
  }
}
