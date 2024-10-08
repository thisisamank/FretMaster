import 'package:dyte_uikit_flutter_starter_app/core/scale.dart';
import 'package:dyte_uikit_flutter_starter_app/notifier/note_notifier.dart';
import 'package:dyte_uikit_flutter_starter_app/notifier/states/note_states.dart';
import 'package:dyte_uikit_flutter_starter_app/notifier/timer_notifier.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/circular_timer_widget.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/fretboard_widget.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/scale_list_widget.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/set_timer_widget.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/space/vh_space.dart';
import 'package:flutter/material.dart';

class ScaleNotePractice extends StatefulWidget {
  const ScaleNotePractice({super.key});

  @override
  _ScaleNotePracticeState createState() => _ScaleNotePracticeState();
}

class _ScaleNotePracticeState extends State<ScaleNotePractice> {
  late final NoteNotifier _noteNotifier;
  late TimerNotifier _timerNotifier;
  int _interval = 5000;

  Notes _selectedNote = Notes.A;
  Scales _selectedScale = Scales.major;

  @override
  void initState() {
    super.initState();
    _noteNotifier = NoteNotifier(_selectedNote, _selectedScale);
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
        _interval = newInterval * 1000; // Convert seconds to milliseconds
        _timerNotifier.resetTimer(_interval);
        _resetPractice();
      });
    }
  }

  void _handleNoteChange() {
    if (_noteNotifier.value is! AllNotesPlayed) {
      _noteNotifier.getNextNote();
      _timerNotifier.resetTimer(_interval);
      _timerNotifier.startTimer();
    } else {
      _timerNotifier.stopTimer();
    }
  }

  void _updatePractice() {
    _timerNotifier.stopTimer();
    _noteNotifier.changeNoteAndScale(_selectedNote, _selectedScale);
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
        title: const Text('Scale Note Practice'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                              setState(() {
                                _selectedNote = newNote;
                                _updatePractice();
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 10),
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
                              setState(() {
                                _selectedScale = newScale;
                                _updatePractice();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    vspace1,
                    ScaleListWidget(selectedNote: _selectedNote, selectedScale: _selectedScale),
                    vspace3,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SetTimerWidget(_updateInterval),
                    ),
                    vspace3,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _noteNotifier.getNextNote,
                          child: const Text('Next Note'),
                        ),
                        hspace1,
                        ElevatedButton(
                          onPressed: _resetPractice,
                          child: const Text('Reset Notes'),
                        ),
                      ],
                    ),
                    vspace3,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _timerNotifier.startTimer,
                          child: const Text('Start Timer'),
                        ),
                        hspace1,
                        ElevatedButton(
                          onPressed: _timerNotifier.stopTimer,
                          child: const Text('Stop Timer'),
                        ),
                      ],
                    ),
                  ],
                ),
                hspace3, // Add horizontal space between columns
                // Second Column with CircularTimerWidget
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
            // Fretboard Widget
            Center(
              child: ValueListenableBuilder(
                valueListenable: _noteNotifier,
                builder: (context, NoteStates state, child) {
                  if (state is CurrentNote) {
                    return FretboardWidget(
                      tuning: const ['E', 'A', 'D', 'G', 'B', 'E'],
                      highlightedNotes: {state.note},
                      totalFrets: 17,
                    );
                  } else {
                    return FretboardWidget(
                      tuning: const ['E', 'A', 'D', 'G', 'B', 'E'],
                      highlightedNotes: _noteNotifier.getNotes().toSet(),
                      totalFrets: 17,

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
