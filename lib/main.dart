import 'package:dyte_uikit_flutter_starter_app/pages/exercises/random_note_practice.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/exercises/scale_chords_practice.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/exercises/scale_note_practice.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/size/size_config.dart';
import 'package:dyte_uikit_flutter_starter_app/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

 class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      title: 'Music Practice App',
      theme: AppTheme.lightTheme,
      home: const PracticeHomePage(),
    );
  }
}


class PracticeHomePage extends StatelessWidget {
  const PracticeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Widget>> practiceOptions = [
      {
        'title': const Text('Random Note Practice'),
        'page': const RandomNotePractice(),
      },
      {
        'title': const Text('Scale Note Practice'),
        'page': const ScaleNotePractice(),
      },
      {
        'title': const Text('Scale Chords Practice'),
        'page': const ScaleChordsPractice(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Practice Exercises'),
      ),
      body: Center(
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          shrinkWrap: true,
          itemCount: practiceOptions.length,
          itemBuilder: (context, index) {
            final option = practiceOptions[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => option['page'] as Widget),
                  );
                },
                child: ListTile(
                  title: option['title'],
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
