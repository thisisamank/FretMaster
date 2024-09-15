import 'package:dyte_uikit_flutter_starter_app/core/scale.dart';
import 'package:dyte_uikit_flutter_starter_app/notifier/note_notifier.dart';
import 'package:dyte_uikit_flutter_starter_app/notifier/states/note_states.dart';
import 'package:dyte_uikit_flutter_starter_app/notifier/timer_notifier.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/circular_timer_widget.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/fretboard_widget.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/set_timer_widget.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/space/vh_space.dart';
import 'package:flutter/material.dart';
class ScaleChordsPractice extends StatefulWidget {
  const ScaleChordsPractice({super.key});

  @override
  _ScaleChordsPracticeState createState() => _ScaleChordsPracticeState();
}

class _ScaleChordsPracticeState extends State<ScaleChordsPractice> {
  late final NoteNotifier _chordNotifier;
  late TimerNotifier _timerNotifier;
  int _interval = 5000;

  Notes _selectedNote = Notes.A;
  Scales _selectedScale = Scales.major;

  @override
  void initState() {
    super.initState();
    _chordNotifier = NoteNotifier(_selectedNote, _selectedScale);
    _timerNotifier = TimerNotifier(_interval, _interval, _handleChordChange);
  }

  void _resetPractice() {
    _timerNotifier.resetTimer(_interval);
    _chordNotifier.resetNotes();
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

  void _handleChordChange() {
    if (_chordNotifier.value is! AllChordsPlayed) {
      _chordNotifier.getNextChord();
      _timerNotifier.resetTimer(_interval);
      _timerNotifier.startTimer();
    } else {
      _timerNotifier.stopTimer();
    }
  }

  void _updatePractice() {
    _timerNotifier.stopTimer();
    _chordNotifier.changeNoteAndScale(_selectedNote, _selectedScale);
  }

  @override
  void dispose() {
    _timerNotifier.dispose();
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main Row containing two columns
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Column with controls
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          onPressed: _chordNotifier.getNextChord,
                          child: const Text('Next Chord'),
                        ),
                        hspace1,
                        ElevatedButton(
                          onPressed: _resetPractice,
                          child: const Text('Reset Chords'),
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
                  valueListenable: _chordNotifier,
                  builder: (context, NoteStates state, child) {
                    Widget childWidget;
                    if (state is CurrentChord) {
                      childWidget = Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${state.chord.number}',
                            style: const TextStyle(fontSize: 28),
                          ),
                          Text(
                            '${state.chord.root}${state.chord.type}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      );
                    } else if (state is AllChordsPlayed) {
                      childWidget = const Text('Done!');
                    } else {
                      childWidget = const Text('...');
                    }

                    return ValueListenableBuilder<int>(
                      valueListenable: _timerNotifier,
                      builder: (context, remainingTime, child) {
                        return CircularTimerWidget(
                          remainingTime: remainingTime,
                          totalTime: _interval,
                          child: childWidget,
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
                valueListenable: _chordNotifier,
                builder: (context, NoteStates state, child) {
                  return FretboardWidget(
                      tuning: const ['E', 'A', 'D', 'G', 'B', 'E'],
                      highlightedNotes: _chordNotifier.getNotes().toSet(),
                    );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
