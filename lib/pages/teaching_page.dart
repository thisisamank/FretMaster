import 'package:dyte_uikit_flutter_starter_app/core/scale.dart';
import 'package:dyte_uikit_flutter_starter_app/notifier/note_notifier.dart';
import 'package:dyte_uikit_flutter_starter_app/notifier/states/note_states.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/fretboard_widget.dart';
import 'package:dyte_uikit_flutter_starter_app/pages/widgets/space/vh_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

class TeachingPage extends StatefulWidget {
  const TeachingPage({super.key});

  @override
  _TeachingPageState createState() => _TeachingPageState();
}

class _TeachingPageState extends State<TeachingPage> {
  late NoteNotifier _noteNotifier;
  Notes _selectedNote = Notes.C;
  Scales _selectedScale = Scales.major;
  final DrawingController _drawingController = DrawingController();

  Color _selectedColor = Colors.black;
  double _colorOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _noteNotifier = NoteNotifier(_selectedNote, _selectedScale);
    _drawingController.setStyle(
      color: _selectedColor.withOpacity(_colorOpacity),
    );
  }

  void _updatePractice() {
    _noteNotifier.changeNoteAndScale(_selectedNote, _selectedScale);
  }

  @override
  void dispose() {
    _noteNotifier.dispose();
    _drawingController.dispose();
    super.dispose();
  }

  void _changePenColor(Color color) {
    setState(() {
      _selectedColor = color;
      _drawingController.setStyle(
        color: _selectedColor.withOpacity(_colorOpacity),
      );
    });
  }

  void _changePenOpacity(double opacity) {
    setState(() {
      _colorOpacity = opacity;
      _drawingController.setStyle(
        color: _selectedColor.withOpacity(_colorOpacity),
      );
    });
  }

  Future<void> _showColorPicker() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Pen Color'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      children: [
                        Text('Opacity: ${(_colorOpacity * 100).round()}%'),
                        Slider(
                          value: _colorOpacity,
                          min: 0.0,
                          max: 1.0,
                          onChanged: (double value) {
                            setState(() {
                              _changePenOpacity(value);
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    ...[
                      Colors.black,
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                      Colors.yellow,
                      Colors.purple,
                      Colors.orange,
                      Colors.brown,
                      Colors.grey,
                    ].map((Color color) {
                      return GestureDetector(
                        onTap: () {
                          _changePenColor(color);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: _selectedColor == color
                                ? Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  )
                                : null,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Remove SingleChildScrollView for simplicity if content fits on screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teaching Page'),
        // No need to add pen color selector in AppBar since it's in the toolbar
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          vspace2,
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
              hspace1,
              DropdownButton<Scales>(
                value: _selectedScale,
                items: Scales.values.map((Scales scale) {
                  return DropdownMenuItem<Scales>(
                    value: scale,
                    child: Text(
                      scale.name.replaceAll('_', ' ').toUpperCase(),
                    ),
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
          vspace2,
          // Display Selected Note and Scale
          Text(
            'Scale: ${noteValues[_selectedNote]} ${_selectedScale.name.replaceAll('_', ' ').toUpperCase()}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          vspace1,
          // Display Scale Notes
          ValueListenableBuilder<NoteStates>(
            valueListenable: _noteNotifier,
            builder: (context, state, child) {
              String notesText = _noteNotifier.getNotes().join(', ');
              return Text(
                'Notes: $notesText',
                style: const TextStyle(fontSize: 16),
              );
            },
          ),
          vspace1,
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return DrawingBoard(
                  controller: _drawingController,
                  background: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.white,
                    ),
                    width: constraints.maxWidth,
                    height: 400,
                    child: ValueListenableBuilder<NoteStates>(
                      valueListenable: _noteNotifier,
                      builder: (context, state, child) {
                        Set<String> highlightedNotes =
                            _noteNotifier.getNotes().toSet();
                        return Center(
                          child: FretboardWidget(
                            tuning: const ['E', 'A', 'D', 'G', 'B', 'E'],
                            highlightedNotes: highlightedNotes,
                            totalFrets: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  showDefaultActions: true,
                  showDefaultTools: true,
                  defaultToolsBuilder: (Type activeType, _) {
                    return DrawingBoard.defaultTools(activeType, _drawingController)
                      ..insert(
                        2, // Insert at position 2 (adjust as needed)
                        DefToolItem(
                          icon: Icons.color_lens,
                          isActive: false,
                          onTap: _showColorPicker,
                        ),
                      );
                  },
                );
              },
            ),
          ),
          vspace2,
        ],
      ),
    );
  }
}
