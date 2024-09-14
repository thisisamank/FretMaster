import 'package:dyte_uikit_flutter_starter_app/core/scale.dart';
import 'package:dyte_uikit_flutter_starter_app/notifier/states/note_states.dart';
import 'package:flutter/material.dart';

class NoteNotifier extends ValueNotifier<NoteStates> {
  NoteNotifier(this.note, this.scale) : _noteGenerator = RandomNoteGenerator(note, scale), super(InitialNote());

  final Notes note;
  final Scales? scale;

  late final RandomNoteGenerator _noteGenerator;


  void getRandomNote() {
    value = CurrentNote(_noteGenerator.getRandomNote());
  }

  void getNextNote() {
    if (_noteGenerator.hasRemainingNotes()) {
      value = CurrentNote(_noteGenerator.getNextNote());
    } else {
      value = AllNotesPlayed();
    }
  }

  void resetNotes() {
    _noteGenerator.reset();
    value = InitialNote();
  }

  void changeScale(Scales newScale) {
    _noteGenerator = RandomNoteGenerator(note, newScale);
    resetNotes();
  }

  void changeNoteAndScale(Notes newNote, Scales newScale) {
    _noteGenerator = RandomNoteGenerator(newNote, newScale);
    resetNotes();
  }
  
  void getNextChord() {
    if (_noteGenerator.hasRemainingChords()) {
      value = CurrentChord(_noteGenerator.getNextChord());
    } else {
      value = AllChordsPlayed();
    }
  }

  List<Chord> getChords() {
    return _noteGenerator.getChords();
  }

  List<String> getNotes() {
    return _noteGenerator.getNotes();
  }

}
