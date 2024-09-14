// ignore_for_file: constant_identifier_names

import 'dart:math';

enum Scales {
  major,
  minor,
  dorian,
  mixolydian,
  lydian,
  phrygian,
  locrian
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
  GSharp
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
    var scale = <int>[];

    if (scaleName == null) {
      return notes;
    }

    switch (scaleName) {
      case Scales.major:
        scale = [0, 2, 4, 5, 7, 9, 11];
        break;
      case Scales.minor:
        scale = [0, 2, 3, 5, 7, 8, 10];
        break;
      case Scales.dorian:
        scale = [0, 2, 3, 5, 7, 9, 10];
        break;
      case Scales.mixolydian:
        scale = [0, 2, 4, 5, 7, 9, 10];
        break;
      case Scales.lydian:
        scale = [0, 2, 4, 6, 7, 9, 11];
        break;
      case Scales.phrygian:
        scale = [0, 1, 3, 5, 7, 8, 10];
        break;
      case Scales.locrian:
        scale = [0, 1, 3, 5, 6, 8, 10];
        break;
    }

    // Map the scale intervals to notes and return the corresponding note names
    return scale.map((i) => notes[(tonicIndex + i) % notes.length]).toList();
  }
}

class RandomNoteGenerator {
  final List<String> _notes;
  final Random _random = Random();
  final List<String> _remainingNotes = [];
  final List<Chord> _remainingChords = [];
  final List<Chord> _chords = [];

  RandomNoteGenerator(Notes tonic, Scales? scaleName)
      : _notes = Scale.getScale(tonic, scaleName){
    _remainingNotes.addAll(_notes);
    _chords.addAll(generateChords());
    _remainingChords.addAll(generateChords());
  }

  List<Chord> getChords() {
    return _chords;
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
      ..addAll(generateChords());
  }

  // Function to generate chords using the Chord class
  List<Chord> generateChords() {
    // Chord qualities for the major scale degrees
    const chordQualities = ['maj', 'min', 'min', 'maj', 'maj', 'min', 'dim'];

    var chords = <Chord>[];

    int scaleLength = _notes.length;

    for (var i = 0; i < scaleLength; i++) {
      var root = _notes[i];
      var third = _notes[(i + 2) % scaleLength]; // Third degree
      var fifth = _notes[(i + 4) % scaleLength]; // Fifth degree
      var quality = chordQualities[i % 7];

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
