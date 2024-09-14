import 'package:dyte_uikit_flutter_starter_app/pages/exercises/random_note_practice.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/exercises/scale_chords_practice.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/exercises/scale_note_practice.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/size/size_config.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Main UI class
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      title: 'Music Practice App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PracticeHomePage(),
    );
  }
}

class PracticeHomePage extends StatelessWidget {
  const PracticeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Practice Exercises'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RandomNotePractice()),
                );
              },
              child: const Text('Random Note Practice'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScaleNotePractice()),
                );
              },
              child: const Text('Scale Note Practice'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScaleChordsPractice()),
                );
              },
              child: const Text('Scale Chords Practice'),
            ),
          ],
        ),
      ),
    );
  }
}

