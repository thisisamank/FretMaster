import 'dart:async';

import 'package:dyte_uikit_flutter_starter_app/core/scale.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/exercises/circular_timer_widget.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/scale_list_widget.dart';
import 'package:dyte_uikit_flutter_starter_app/riverpod/note_notifier.dart';
import 'package:dyte_uikit_flutter_starter_app/riverpod/states/note_states.dart';
import 'package:flutter/material.dart';

class ScaleNotePractice extends StatefulWidget {
  const ScaleNotePractice({super.key});

  @override
  _ScaleNotePracticeState createState() => _ScaleNotePracticeState();
}

class _ScaleNotePracticeState extends State<ScaleNotePractice> {
  late NoteNotifier _scaleNoteNotifier;
  Notes _selectedNote = Notes.A;
  Scales _selectedScale = Scales.major;
  Timer? _timer;
  bool _isTimerRunning = false;
  int _interval = 5;
  int _remainingTime = 0;
  final TextEditingController _intervalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializePractice();
    _intervalController.text = _interval.toString();
  }

  void _initializePractice() {
    _scaleNoteNotifier = NoteNotifier(_selectedNote, _selectedScale);
    _remainingTime = _interval;
  }

  void _updatePractice() {
    _stopTimer();
    _scaleNoteNotifier.dispose();
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
        if (_scaleNoteNotifier.value is! AllNotesPlayed) {
          _scaleNoteNotifier.getNextNote();
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
    _scaleNoteNotifier.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  void _onIntervalChange(String value) {
    final int? newInterval = int.tryParse(value);
    if (newInterval != null && newInterval > 0) {
      setState(() {
        _interval = newInterval;
        _remainingTime = _interval;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scale Note Practice'),
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
            ScaleListWidget(selectedNote: _selectedNote, selectedScale: _selectedScale),
            // TextField for setting the interval
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
                      onSubmitted: (_) => _onIntervalChange, // Update interval on submitting
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _onIntervalChange(_intervalController.text),
                    child: const Text('Set'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Circular Timer and Note Display
            ValueListenableBuilder<NoteStates>(
              valueListenable: _scaleNoteNotifier,
              builder: (context, state, child) {
                String currentNote = 'Start Timer';
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
          ],
        ),
      ),
    );
  }
}
