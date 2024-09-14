import 'dart:async';

import 'package:dyte_uikit_flutter_starter_app/core/scale.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/exercises/circular_timer_widget.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/space/vh_space.dart';
import 'package:dyte_uikit_flutter_starter_app/riverpod/note_notifier.dart';
import 'package:dyte_uikit_flutter_starter_app/riverpod/states/note_states.dart';
import 'package:flutter/material.dart';

class RandomNotePractice extends StatefulWidget {
  const RandomNotePractice({super.key});

  @override
  _RandomNotePracticeState createState() => _RandomNotePracticeState();
}

class _RandomNotePracticeState extends State<RandomNotePractice> {
  late final NoteNotifier _noteNotifier;
  Timer? _timer;
  bool _isTimerRunning = false;
  int _interval = 5; // Default timer interval in seconds
  int _remainingTime = 0; // For tracking the remaining time in the timer
  final TextEditingController _intervalController = TextEditingController(); // Controller for the timer input

  @override
  void initState() {
    _noteNotifier = NoteNotifier(Notes.A, Scales.major);
    _remainingTime = _interval;
    _intervalController.text = _interval.toString(); // Initialize text box with default interval
    super.initState();
  }

  // Function to start the timer
  void _startTimer() {
    if (_isTimerRunning) return; // Prevent multiple timers

    _isTimerRunning = true;
    _remainingTime = _interval;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        if (_noteNotifier.value is! AllNotesPlayed) {
          _noteNotifier.getNextNote();
          _remainingTime = _interval;
        } else {
          timer.cancel();
          _isTimerRunning = false;
        }
      }
    });
  }

  // Function to stop the timer
  void _stopTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _isTimerRunning = false;
    }
  }

  // Function to reset the timer and notes
  void _resetPractice() {
    _stopTimer();
    _remainingTime = _interval;
    _noteNotifier.resetNotes();
  }

  void _updateInterval() {
    setState(() {
      _interval = int.tryParse(_intervalController.text) ?? _interval; // Set the interval from the text box input
      _remainingTime = _interval;
      _resetPractice(); // Reset practice to apply new interval
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    _intervalController.dispose(); // Dispose the text controller
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
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Set Timer (seconds): '),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _intervalController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _updateInterval(), // Update interval on submitting
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _updateInterval,
                    child: const Text('Set'),
                  ),
                ],
              ),
            ),
            vspace3,
            // Circular timer and note display
            ValueListenableBuilder(
              valueListenable: _noteNotifier,
              builder: (context, NoteStates state, child) {
                String currentNote = '...';
                if (state is CurrentNote) {
                  currentNote = state.note;
                } else if (state is AllNotesPlayed) {
                  currentNote = 'Done!';
                }

                return CircularTimerWidget(
                  remainingTime: _remainingTime,
                  totalTime: _interval,
                  child: Text(
                    currentNote,
                    style: const TextStyle(fontSize: 24),
                  ),
                );
              },
            ),
            vspace3,
            ElevatedButton(
              onPressed: _noteNotifier.getNextNote,
              child: const Text('Next Note'),
            ),
            vspace2,
            ElevatedButton(
              onPressed: _resetPractice,
              child: const Text('Reset Notes'),
            ),
            vspace4,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  child: const Text('Start Timer'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _stopTimer,
                  child: const Text('Stop Timer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}