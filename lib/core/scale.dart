// ignore_for_file: constant_identifier_names

import 'dart:math';

enum Scales {
  major,
  minor,
  dorian,
  mixolydian,
  lydian,
  phrygian,
  locrian,
  major_pentatonic,
  minor_pentatonic,
  blues,
}

enum Notes {
  A,
  ASharp,
  B,
  C,
  CSharp,
  D,
  DSharp,
  E,
  F,
  FSharp,
  G,
  GSharp,
}

const noteValues = {
  Notes.A: 'A',
  Notes.ASharp: 'A#',
  Notes.B: 'B',
  Notes.C: 'C',
  Notes.CSharp: 'C#',
  Notes.D: 'D',
  Notes.DSharp: 'D#',
  Notes.E: 'E',
  Notes.F: 'F',
  Notes.FSharp: 'F#',
  Notes.G: 'G',
  Notes.GSharp: 'G#',
};

class Chord {
  final String root;
  final String type;
  final List<String> notes;
  final int number;

  Chord(this.root, this.type, this.notes, this.number);

  @override
  String toString() {
    return '$number$root$type: ${notes.join(', ')}';
  }
}

class Scale {
  static List<String> getScale(Notes tonic, Scales? scaleName) {
    final notes = Notes.values.map((e) => noteValues[e]!).toList();
    final tonicIndex = notes.indexOf(noteValues[tonic]!);
    var scaleIntervals = <int>[];

    if (scaleName == null) {
      return notes;
    }

    switch (scaleName) {
      case Scales.major:
        scaleIntervals = [0, 2, 4, 5, 7, 9, 11];
        break;
      case Scales.minor:
        scaleIntervals = [0, 2, 3, 5, 7, 8, 10];
        break;
      case Scales.dorian:
        scaleIntervals = [0, 2, 3, 5, 7, 9, 10];
        break;
      case Scales.mixolydian:
        scaleIntervals = [0, 2, 4, 5, 7, 9, 10];
        break;
      case Scales.lydian:
        scaleIntervals = [0, 2, 4, 6, 7, 9, 11];
        break;
      case Scales.phrygian:
        scaleIntervals = [0, 1, 3, 5, 7, 8, 10];
        break;
      case Scales.locrian:
        scaleIntervals = [0, 1, 3, 5, 6, 8, 10];
        break;
      case Scales.major_pentatonic:
        scaleIntervals = [0, 2, 4, 7, 9]; // Intervals for major pentatonic
        break;
      case Scales.minor_pentatonic:
        scaleIntervals = [0, 3, 5, 7, 10]; // Intervals for minor pentatonic
        break;
      case Scales.blues:
        scaleIntervals = [0, 3, 5, 6, 7, 10]; // Intervals for blues scale
        break;
    }

    // Map the scale intervals to notes and return the corresponding note names
    return scaleIntervals
        .map((i) => notes[(tonicIndex + i) % notes.length])
        .toList();
  }
}

class RandomNoteGenerator {
  final List<String> _notes;
  final Random _random = Random();
  final List<String> _remainingNotes = [];
  final List<Chord> _remainingChords = [];
  final List<Chord> _chords = [];

  final List<int> _last3RandomIndexes = [];

  RandomNoteGenerator(Notes tonic, Scales? scaleName)
      : _notes = Scale.getScale(tonic, scaleName) {
    _remainingNotes.addAll(_notes);
    _chords.addAll(generateChords(tonic, scaleName));
    _remainingChords.addAll(_chords);
  }

  List<Chord> getChords() {
    return _chords;
  }

  String getRandomNote() {
    int randomIndex = _random.nextInt(_notes.length);
    while (_last3RandomIndexes.contains(randomIndex)) {
      randomIndex = _random.nextInt(_notes.length);
    }
    _last3RandomIndexes.add(randomIndex);
    if (_last3RandomIndexes.length > 3) {
      _last3RandomIndexes.removeAt(0);
    }
    return _notes[randomIndex];
  }

  List<String> getNotes() {
    return _notes;
  }

  // Function to get the next random note from the scale until all are exhausted
  String getNextNote() {
    if (_remainingNotes.isEmpty) {
      throw Exception('All notes have been played.');
    }
    int randomIndex = _random.nextInt(_remainingNotes.length);
    String note = _remainingNotes.removeAt(randomIndex);
    return note;
  }

  // Function to check if all notes have been exhausted
  bool hasRemainingNotes() {
    return _remainingNotes.isNotEmpty;
  }

  // Function to reset the notes and chords, making it reusable
  void reset() {
    _remainingNotes
      ..clear()
      ..addAll(_notes);
    _remainingChords
      ..clear()
      ..addAll(_chords);
  }

  // Function to generate chords using the Chord class
  static List<Chord> generateChords(Notes tonic, Scales? scaleName) {
    final notes = Scale.getScale(tonic, scaleName);
    final scaleLength = notes.length;

    // Define chord qualities for each scale
    Map<Scales, List<String>> scaleChordQualities = {
      Scales.major: ['maj', 'min', 'min', 'maj', 'maj', 'min', 'dim'],
      Scales.minor: ['min', 'dim', 'maj', 'min', 'min', 'maj', 'maj'],
      Scales.major_pentatonic: ['maj', 'maj', 'min', 'min', 'maj'],
      Scales.minor_pentatonic: ['min', 'min', 'maj', 'maj', 'min'],
      Scales.blues: ['min7', 'min', 'maj', 'dim', 'maj', 'min7'],
      // Add chord qualities for other scales if needed
    };

    var chordQualities = scaleChordQualities[scaleName] ??
        ['maj', 'min', 'min', 'maj', 'maj', 'min', 'dim'];

    var chords = <Chord>[];

    for (var i = 0; i < scaleLength; i++) {
      var root = notes[i];
      var thirdIndex = (i + 2) % scaleLength; // Third degree
      var fifthIndex = (i + 4) % scaleLength; // Fifth degree

      var third = notes[thirdIndex];
      var fifth = notes[fifthIndex];
      var quality = chordQualities[i % chordQualities.length];

      var chordNotes = [root, third, fifth];
      chords.add(Chord(root, quality, chordNotes, i + 1));
    }

    return chords;
  }

  // Function to get a random chord until all are exhausted
  Chord getNextChord() {
    if (_remainingChords.isEmpty) {
      throw Exception('All chords have been played.');
    }

    int randomIndex = _random.nextInt(_remainingChords.length);
    Chord chord = _remainingChords.removeAt(randomIndex);
    return chord;
  }

  // Function to check if there are remaining chords
  bool hasRemainingChords() {
    return _remainingChords.isNotEmpty;
  }
}
