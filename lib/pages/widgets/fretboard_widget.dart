import 'dart:math';

import 'package:dyte_uikit_flutter_starter_app/pages/widgets/space/vh_space.dart';
import 'package:flutter/material.dart';

class FretboardPainter extends CustomPainter {
  final BuildContext context; // Added BuildContext
  final List<String> tuning;
  final Set<String> highlightedNotes;
  final Set<String>? highlightedChords;
  final String rootNote;
  final int totalFrets;
  final Color fretColor;
  final Color stringColor;
  final Color noteColor;
  final Color noteTextColor;

  FretboardPainter({
    required this.context, // Added BuildContext
    required this.tuning,
    required this.highlightedNotes,
    this.highlightedChords,
    this.totalFrets = 18,
    required this.fretColor,
    required this.stringColor,
    required this.noteColor,
    required this.noteTextColor,
    required this.rootNote,
  });

  static const List<String> chromaticScale = [
    'C', 'C#', 'D', 'D#', 'E', 'F',
    'F#', 'G', 'G#', 'A', 'A#', 'B'
  ];

  static const double scaleLength = 800.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Get the root note color from the theme
    final Color rootNoteColor = Theme.of(context).colorScheme.secondary;

    List<double> fretPositions = _calculateEvenFretPositions(scaleLength);
    double totalFretboardLength = fretPositions.last;
    double scaleFactor = size.width / totalFretboardLength;
    List<double> normalizedFrets =
        fretPositions.map((pos) => pos * scaleFactor).toList();
    double stringSpacing = size.height / (tuning.length - 1);

    // Draw frets
    Paint fretPaint = Paint()
      ..color = fretColor
      ..strokeWidth = 1.0;
    for (double x in normalizedFrets) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), fretPaint);
    }

    // Draw strings
    Paint stringPaint = Paint()
      ..color = stringColor
      ..strokeWidth = 1.0;
    for (int i = 0; i < tuning.length; i++) {
      double y = i * stringSpacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), stringPaint);
    }

    // Prepare chord notes and root notes sets
    Set<String> chordNotesSet = {};
    if (highlightedChords != null) {
      for (String chord in highlightedChords!) {
        Set<String>? notes = getNotesInChord(chord);
        if (notes != null) {
          chordNotesSet.addAll(notes);
        }
      }
    }

    // Map notes to fret positions
    for (int stringIndex = 0; stringIndex < tuning.length; stringIndex++) {
      String openNote = tuning[stringIndex];
      int startIndex = chromaticScale.indexOf(openNote);

      // For each fret on the string (starting from 1 to exclude open strings)
      for (int fret = 1; fret <= totalFrets; fret++) {
        int noteIndex = (startIndex + fret) % chromaticScale.length;
        String note = chromaticScale[noteIndex];

        bool isNoteHighlighted = highlightedNotes.contains(note);
        bool isChordHighlighted = chordNotesSet.contains(note);
        bool isRootNote = rootNote == note;

        if (isNoteHighlighted || isChordHighlighted) {
          double x = (normalizedFrets[fret - 1] + normalizedFrets[fret]) / 2;
          double y = stringIndex * stringSpacing;
          Paint circlePaint = Paint()
            ..color = isRootNote ? rootNoteColor : noteColor;
          canvas.drawCircle(Offset(x, y), stringSpacing / 2.5, circlePaint);

          TextPainter textPainter = TextPainter(
            text: TextSpan(
              text: note,
              style: TextStyle(color: noteTextColor, fontSize: 12),
            ),
            textDirection: TextDirection.ltr,
          );
          textPainter.layout(minWidth: 0, maxWidth: size.width);
          textPainter.paint(
              canvas,
              Offset(x - textPainter.width / 2, y - textPainter.height / 2));
        }
      }
    }

    // Add fret markers
    List<int> fretMarkers = [3, 5, 7, 9, 12, 15, 17, 19, 21];
    for (int fret in fretMarkers) {
      if (fret <= totalFrets) {
        double x = (normalizedFrets[fret - 1] + normalizedFrets[fret]) / 2;

        if (fret == 12) {
          // Draw double markers for the 12th fret
          double yTop = size.height * 0.3;
          double yBottom = size.height * 0.7;
          Paint markerPaint = Paint()..color = fretColor;
          canvas.drawCircle(Offset(x, yTop), 5.0, markerPaint);
          canvas.drawCircle(Offset(x, yBottom), 5.0, markerPaint);
        } else {
          // Draw single marker for other frets
          double y = size.height / 2;
          Paint markerPaint = Paint()..color = fretColor;
          canvas.drawCircle(Offset(x, y), 5.0, markerPaint);
        }
      }
    }
  }

  List<double> _calculateFretPositions(double scaleLength) {
    List<double> positions = [0.0];
    for (int fret = 1; fret <= totalFrets; fret++) {
      double position = scaleLength - (scaleLength / pow(2, fret / 12));
      positions.add(position);
    }
    return positions;
  }

  List<double> _calculateEvenFretPositions(double fretboardWidth) {
    List<double> positions = [];
    double fretWidth = fretboardWidth / totalFrets;
    for (int fret = 0; fret <= totalFrets; fret++) {
      positions.add(fret * fretWidth);
    }
    return positions;
  }

  // Function to get the notes in a major chord
  Set<String>? getNotesInChord(String chordName) {
    int rootIndex = chromaticScale.indexOf(chordName);
    if (rootIndex == -1) return null; // Chord not found
    // Major chord intervals: root, major third, perfect fifth
    int majorThirdIndex = (rootIndex + 4) % chromaticScale.length;
    int perfectFifthIndex = (rootIndex + 7) % chromaticScale.length;

    return {
      chromaticScale[rootIndex],
      chromaticScale[majorThirdIndex],
      chromaticScale[perfectFifthIndex],
    };
  }

  @override
  bool shouldRepaint(covariant FretboardPainter oldDelegate) {
    return oldDelegate.highlightedNotes != highlightedNotes ||
        oldDelegate.tuning != tuning ||
        oldDelegate.highlightedChords != highlightedChords ||
        oldDelegate.totalFrets != totalFrets ||
        oldDelegate.fretColor != fretColor ||
        oldDelegate.stringColor != stringColor ||
        oldDelegate.noteColor != noteColor ||
        oldDelegate.noteTextColor != noteTextColor;
  }
}

class FretboardWidget extends StatefulWidget {
  final List<String> tuning;
  final Set<String> highlightedNotes;
  final Set<String>? highlightedChords;
  final int totalFrets;
  final String rootNote;

  FretboardWidget({
    super.key,
    required this.tuning,
    required this.highlightedNotes,
    this.highlightedChords,
    this.totalFrets = 22,
  }) : rootNote = highlightedNotes.first;

  @override
  State<FretboardWidget> createState() => _FretboardWidgetState();
}

class _FretboardWidgetState extends State<FretboardWidget> {
  bool _toShowFretboard = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fretColor = theme.dividerColor.withOpacity(0.4); // Color for frets
    final stringColor = theme.dividerColor.withOpacity(0.4); // Color for strings
    final noteColor = theme.highlightColor.withOpacity(0.7); // Color for highlighted notes
    const noteTextColor = Colors.white; // Color for note text

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Show Fretboard'),
              Switch(
                value: _toShowFretboard,
                onChanged: (value) {
                  setState(() {
                    _toShowFretboard = value;
                  });
                },
              ),
            ],
          ),
          vspace2,
          if (_toShowFretboard)
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2,
              child: CustomPaint(
                painter: FretboardPainter(
                  context: context,
                  tuning: widget.tuning,
                  highlightedNotes: widget.highlightedNotes,
                  highlightedChords: widget.highlightedChords,
                  totalFrets: widget.totalFrets,
                  fretColor: fretColor,
                  stringColor: stringColor,
                  noteColor: noteColor,
                  noteTextColor: noteTextColor,
                  rootNote: widget.rootNote,
                ),
                child: Container(),
              ),
            ),
          if (!_toShowFretboard)
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
        ],
      ),
    );
  }
}
