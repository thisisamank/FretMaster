import 'dart:async';

import 'package:dyte_uikit_flutter_starter_app/core/scale.dart';
import 'package:dyte_uikit_flutter_starter_app/notifier/note_notifier.dart';
import 'package:dyte_uikit_flutter_starter_app/notifier/states/note_states.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/circular_timer_widget.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/space/vh_space.dart';
import 'package:flutter/material.dart';

class ScaleChordsPractice extends StatefulWidget {
  const ScaleChordsPractice({super.key});

  @override
  _ScaleChordsPracticeState createState() => _ScaleChordsPracticeState();
}

class _ScaleChordsPracticeState extends State<ScaleChordsPractice> {
  late NoteNotifier _chordNotifier;
  Notes _selectedNote = Notes.A;
  Scales _selectedScale = Scales.major;
  Timer? _timer;
  bool _isTimerRunning = false;
  int _interval = 5;
  int _remainingTime = 0;

  @override
  void initState() {
    super.initState();
    _initializePractice();
  }

  void _initializePractice() {
    _chordNotifier = NoteNotifier(_selectedNote, _selectedScale);
    _remainingTime = _interval;
  }

  void _updatePractice() {
    _stopTimer();
    _chordNotifier.dispose();
    setState(() {
      _initializePractice();
    });
  }

  void _startTimer() {
    if (_isTimerRunning) return;
    _isTimerRunning = true;
    _remainingTime = _interval;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        if (_chordNotifier.value is! AllNotesPlayed) {
          _chordNotifier.getNextChord();
          _remainingTime = _interval;
        } else {
          timer.cancel();
          _isTimerRunning = false;
        }
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _isTimerRunning = false;
  }

  @override
  void dispose() {
    _stopTimer();
    _chordNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scale Chords Practice'),
      ),
      body: Center(
        child: Column(
          children: [
            // Note and Scale Dropdowns
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<Notes>(
                  value: _selectedNote,
                  items: Notes.values.map((Notes note) {
                    return DropdownMenuItem<Notes>(
                      value: note,
                      child: Text(noteValues[note]!),
                    );
                  }).toList(),
                  onChanged: (Notes? newNote) {
                    if (newNote != null) {
                      _selectedNote = newNote;
                      _updatePractice();
                    }
                  },
                ),
                DropdownButton<Scales>(
                  value: _selectedScale,
                  items: Scales.values.map((Scales scale) {
                    return DropdownMenuItem<Scales>(
                      value: scale,
                      child: Text(scale.name),
                    );
                  }).toList(),
                  onChanged: (Scales? newScale) {
                    if (newScale != null) {
                      _selectedScale = newScale;
                      _updatePractice();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Interval Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Select Interval: '),
                DropdownButton<int>(
                  value: _interval,
                  items: [2, 5, 10, 15].map((int interval) {
                    return DropdownMenuItem<int>(
                      value: interval,
                      child: Text('$interval seconds'),
                    );
                  }).toList(),
                  onChanged: (int? newInterval) {
                    if (newInterval != null) {
                      _interval = newInterval;
                      _updatePractice();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Circular Timer and Chord Display
            CircularTimerWidget(
                  remainingTime: _remainingTime,
                  totalTime: _interval,
                  child:ValueListenableBuilder(
                        valueListenable: _chordNotifier,
                        builder: (context, state, child) {
                          if (state is CurrentChord) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  state.chord.number.toString(),
                                  style: const TextStyle(fontSize: 24),
                                ),
                                Text(
                                  state.chord.root + state.chord.type,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                
                              ],
                            );
                          } else if (state is AllChordsPlayed) {
                            return const Text('Done!');
                          } else {
                            return const Text('...');
                          }
                        },
                  )
            ),
            const SizedBox(height: 20),
            // Start and Stop Timer Buttons
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
            vspace3,
            ElevatedButton(
              onPressed: _chordNotifier.resetNotes,
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}


