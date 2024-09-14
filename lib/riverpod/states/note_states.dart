import 'package:dyte_uikit_flutter_starter_app/core/scale.dart';

class NoteStates {}


class InitialNote extends NoteStates {}

class CurrentNote extends NoteStates {
  final String note;

  CurrentNote(this.note);
}

class AllNotesPlayed extends NoteStates {}


class CurrentChord extends NoteStates {
  final Chord chord;

  CurrentChord(this.chord);
}

class AllChordsPlayed extends NoteStates {}