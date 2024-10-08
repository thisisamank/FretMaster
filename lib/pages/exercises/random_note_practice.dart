import 'package:dyte_uikit_flutter_starter_app/core/scale.dart';
import 'package:dyte_uikit_flutter_starter_app/notifier/note_notifier.dart';
import 'package:dyte_uikit_flutter_starter_app/notifier/states/note_states.dart';
import 'package:dyte_uikit_flutter_starter_app/notifier/timer_notifier.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/circular_timer_widget.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/fretboard_widget.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/set_timer_widget.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/space/vh_space.dart';
import 'package:flutter/material.dart';

class RandomNotePractice extends StatefulWidget {
  const RandomNotePractice({super.key});

  @override
  _RandomNotePracticeState createState() => _RandomNotePracticeState();
}

class _RandomNotePracticeState extends State<RandomNotePractice> {
  late final NoteNotifier _noteNotifier;
  late TimerNotifier _timerNotifier;
  int _interval = 5000;
  @override
  void initState() {
    super.initState();
    _noteNotifier = NoteNotifier(Notes.A, null);
    _timerNotifier = TimerNotifier(_interval, _interval, _handleNoteChange);
  }

  void _resetPractice() {
    _timerNotifier.resetTimer(_interval);
    _noteNotifier.resetNotes();
  }

  void _updateInterval(String value) {
    final int? newInterval = int.tryParse(value);
    if (newInterval != null && newInterval > 0) {
      setState(() {
        _interval = newInterval * 1000; 
        _timerNotifier.resetTimer(_interval);
        _resetPractice();
      });
    }
  }

  void _handleNoteChange() {
    if (_noteNotifier.value is! AllNotesPlayed) {
      _noteNotifier.getRandomNote();
      _timerNotifier.resetTimer(_interval);
      _timerNotifier.startTimer();
    } else {
      _timerNotifier.stopTimer(); 
    }
  }

  @override
  void dispose() {
    _timerNotifier.dispose();
    _noteNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Note Practice'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SetTimerWidget(_updateInterval),
                    ),                
                    vspace3,
                    Row(
                      children: [
                      ElevatedButton(
                      onPressed: _noteNotifier.getRandomNote,
                      child: const Text('Next Note'),
                      ),
                    hspace1,
                    ElevatedButton(
                      onPressed: _resetPractice,
                      child: const Text('Reset Notes'),
                    ),
                      ],
                    ),
                    
                    vspace4,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _timerNotifier.startTimer, // Start the timer
                          child: const Text('Start Timer'),
                        ),
                        hspace1,
                        ElevatedButton(
                          onPressed: _timerNotifier.stopTimer, // Stop the timer
                          child: const Text('Stop Timer'),
                        ),
                      ],
                    ),
                  ],
                ),
                ValueListenableBuilder(
                      valueListenable: _noteNotifier,
                      builder: (context, NoteStates state, child) {
                        String currentNote = '...';
                        if (state is CurrentNote) {
                          currentNote = state.note;
                        } else if (state is AllNotesPlayed) {
                          currentNote = 'Done!';
                        }
                
                        return ValueListenableBuilder<int>(
                          valueListenable: _timerNotifier,
                          builder: (context, remainingTime, child) {
                            return CircularTimerWidget(
                              remainingTime: remainingTime,
                              totalTime: _interval,
                              child: Text(
                                currentNote,
                                style: const TextStyle(fontSize: 24),
                              ),
                            );
                          },
                        );
                      },
                    ),
              ],
            ),
            vspace4,
          Center(
          child: ValueListenableBuilder(
            valueListenable: _noteNotifier,
            builder: (context, NoteStates state, child) {
              if (state is CurrentNote) {
                return FretboardWidget(
                  tuning: const ['E', 'A', 'D', 'G', 'B', 'E'],
                  highlightedNotes: {state.note},
                );
              } else {
                return  FretboardWidget(
                  tuning: const ['E', 'A', 'D', 'G', 'B', 'E'],
                  highlightedNotes: const {},
                );
              }
            },
          ),
        ),
          ],
        ),
      ),
    );
  }
}
